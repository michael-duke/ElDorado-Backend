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

# Expose the port
EXPOSE 3001

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]