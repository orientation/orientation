FROM ruby:2.5.1-alpine

MAINTAINER Olivier Lacan <hi@olivierlacan.com>

RUN apk add --update \
  tzdata \
  build-base \
  postgresql-dev \
  yarn

COPY . /orientation
WORKDIR /orientation

## Gem caching
# The addition of Gemfiles allows the bundle install step to be evicted from the
# build cache when a change is detected.
COPY ./Gemfile /tmp/Gemfile
COPY ./Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --gemfile=/tmp/Gemfile

RUN yarn install

COPY ./config/database.docker.yml /orientation/config/database.yml

ENV RAILS_ENV=production

EXPOSE 3000

CMD [ "bundle", "exec", "foreman", "start" ]
