FROM ruby:latest

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /app

# Install Rails gem
RUN gem install rails

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy application code
COPY . ./

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
