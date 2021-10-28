FROM ruby:3.0.0-alpine

RUN apk add --update --no-cache \ 
    build-base \
    tzdata \
    postgresql-dev \
    nodejs \
    git \
    imagemagick6-dev \
    bash 

# Update CA Certificates
RUN update-ca-certificates

# Set rails env variable
# ARG bundle_options_var='--without development test'
# ARG bundle_options_var=''

# Application path inside container
ENV APP_ROOT /app

# Create application folder
RUN mkdir $APP_ROOT

# Set command execution path
WORKDIR $APP_ROOT

# Copy files to application folder
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
# COPY Gemfile.lock $APP_ROOT/Gemfile.lock

# Install gems
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 0
# RUN bundle install $bundle_options_var
RUN gem install bundler
RUN bundle install
# RUN mkdir -p $APP_ROOT
# COPY Gemfile.lock /tmp

# Copy all project files to application folder inside container
COPY . $APP_ROOT

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000