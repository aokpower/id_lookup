FROM ruby:3.0-alpine

COPY Gemfile Gemfile.lock ./

WORKDIR /app

RUN apk add make gcc musl-dev

RUN gem install bundler && \
    bundle config set without development test && \
    bundle install

COPY . .

CMD ["bundle", "exec", "puma"]
