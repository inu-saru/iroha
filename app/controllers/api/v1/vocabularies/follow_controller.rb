class Api::V1::Vocabularies::FollowController < ApplicationController
  include Spaceable
  before_action :authenticate_user!
  after_action { pagy_headers_merge(@pagy) if @pagy }
  wrap_parameters :vocabulary

  def following
    @following = vocabulary.following.with
    @pagy, @following = pagy(@following)
    render json: FollowResource.new(@following).serialize
  end

  def followers
    @followers = vocabulary.followers.with
    @pagy, @followers = pagy(@followers)
    render json: FollowResource.new(@followers).serialize
  end

  private

  def vocabularies
    return @vocabularies if defined? @vocabularies

    @vocabularies = space.vocabularies.order(created_at: :desc)
  end

  def vocabulary
    return @vocabulary if defined? @vocabulary

    @vocabulary = vocabularies.find(params[:id])
  end

  def filtering_params
    params.slice(:language_type)
  end
end
