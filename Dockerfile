ARG RUBY_VERSION=3.3
FROM ruby:${RUBY_VERSION}

WORKDIR /app
COPY . .
RUN bundle install

CMD ["bundle", "exec", "rspec"]
