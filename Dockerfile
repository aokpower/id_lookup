FROM ruby:2.7

COPY Gemfile Gemfile.lock ./

WORKDIR /app

RUN gem install bundler && bundle install

COPY . .

CMD ["bundle", "exec", "puma"]
