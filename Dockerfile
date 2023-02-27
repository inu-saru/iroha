FROM ruby:3.2.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /iroha
WORKDIR /iroha
COPY Gemfile /iroha/Gemfile
COPY Gemfile.lock /iroha/Gemfile.lock
RUN bundle install
COPY . /iroha

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]