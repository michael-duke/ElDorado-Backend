# Use the official Ruby image
FROM ruby:3.2.1-slim

# Install essential Linux packages for Postgres and Rails
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    git \
    pkg-config
    
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN rm -f /app/tmp/pids/server.pid

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p ${PORT:3001}"]