ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

RUN apt-get update && apt-get install -y cmake && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN bundle install

CMD ["bundle", "exec", "rspec"]
