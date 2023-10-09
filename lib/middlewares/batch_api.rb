class BatchApi
  def initialize(app)
    @app = app
    @store = {}
  end

  def call(env)
    if env['PATH_INFO'] == '/api/v1/batch'
      process_batch(env)
    else
      @app.call(env)
    end
  end

  def process_batch(env)
    responses = []
    request = ActionDispatch::Request.new(env.deep_dup)
    ActiveRecord::Base.transaction do
      request.parameters[:requests].each do |override|
        # 子供は別のtransationを使いたいですので、requires_new: trueをつけます。
        ActiveRecord::Base.transaction(requires_new: true) do
          # 指定したkeyにloop(request)中にstoreにsetしたhashをmergeする
          if override['store_merge_to'].present?
            override = merge_request_params(override)
          end

          response = process_request(env.deep_dup, override)
          responses.push(response)

          # responseの値を、後段の処理で利用するためstoreにsetする
          if override['store'].present? && response[:status] == 200
            merge_store(override, response)
          end
          # 子供は何かエラーは発生した時に、子供のデータをロルバックする
          raise ActiveRecord::Rollback unless success?([response])
        end
      end

      # レスポンスが失敗の場合、全部ロールバックします。
      raise ActiveRecord::Rollback unless success?(responses)
    end

    render_response(responses)
  end

  def merge_request_params(override)
    key = override['store_merge_to']
    override['body'][key].merge!(@store)
    override
  end

  def merge_store(override, response)
    store_key = override['store'].keys[0]
    @store.store(override['store'][store_key], response[:body][store_key])
  end

  def process_request(env, override)
    path, query = override['url'].split('?')
    env['REQUEST_METHOD'] = override['method']
    env['PATH_INFO'] = path
    env['QUERY_STRING'] = query
    env['FROM_BATCH_API'] = true
    env['rack.input'] = StringIO.new(JSON.generate(override['body']))

    status, headers, body = @app.call(env)
    { status:, headers:, body: status == 200 ? JSON.parse(body&.body) : body }
  end

  def render_response(responses)
    # 成功した最初のresponse、もしくは最初のresponseのheaderを全体のheaderとして利用
    success_response = responses&.find { |response| response[:status] == 200 }
    headers = success_response ? success_response[:headers] : responses[0][:headers]

    hash_json = JSON.generate(responses)
    # レスポンスの長さを更新します。
    headers = headers.merge('Content-Length' => hash_json.bytesize)

    [200, headers, [hash_json]]
  end

  def success?(responses)
    responses&.each do |response|
      return false if response[:status] != 200
    end
    true
  end
end
