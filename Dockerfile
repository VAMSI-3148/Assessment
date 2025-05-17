FROM ruby:3.1.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000
EXPOSE 3000

# Start the server by default
CMD ["rails", "server", "-b", "0.0.0.0"]