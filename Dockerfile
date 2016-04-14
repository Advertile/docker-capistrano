FROM ruby:2.3.0

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
WORKDIR /usr/src/app/
RUN bundle install
