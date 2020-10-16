FROM ruby:2.7.1

# Create a local folder for the app assets
RUN mkdir /backend
WORKDIR /backend

# Install required tooling
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client --fix-missing --no-install-recommends

# Set our environment variables
ENV RAILS_ENV production #run the app in production mode
ENV RAILS_SERVE_STATIC_FILES true #serves static files (better performance)
ENV RAILS_LOG_TO_STDOUT true #ensures our rails logs will be exposed from the container (useful for debugging!)

# Copy and install Gems from our Gemfile
COPY Gemfile /backend/Gemfile 
COPY Gemfile.lock /backend/Gemfile.lock

RUN gem install bundler -v 2.0.2

RUN bundle install --deployment

COPY . ./

EXPOSE 3000

# Start the puma server
CMD bundle exec puma -p 3000