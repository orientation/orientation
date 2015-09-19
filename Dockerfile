FROM ruby:2.2.2
MAINTAINER Olivier Lacan <hi@olivierlacan.com>

RUN apt-get update && apt-get upgrade -y

## NodeJS
# See https://github.com/joyent/docker-node/blob/c2dd5e419816ecc760a2ffc18ea762111b87f092/0.12/Dockerfile
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D
ENV NODE_VERSION 0.12.1
ENV NPM_VERSION 2.7.3
RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear

## Bower
RUN npm install -g bower

## Gems caching
# The addition of Gemfiles allows the bundle install step to be evicted from the
# build cache when a change is detected.
ADD ./Gemfile /tmp/Gemfile
ADD ./Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --gemfile=/tmp/Gemfile

ADD . /orientation
WORKDIR /orientation

RUN bower install --allow-root

ADD ./config/database.docker.yml /orientation/config/database.yml

ENV RAILS_ENV=production

EXPOSE 3000

CMD [ "bundle", "exec", "unicorn", "-p", "3000", "-c", "./config/unicorn.rb" ]
