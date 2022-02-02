FROM ruby:2.6.2-alpine as base
ARG REPO_URL="https://github.com/StarGate01/Portus.git"
ARG REPO_TAG="v2.5"
ARG VERSION_STRING="v2.5"

EXPOSE 3000

ENV RACK_ENV=production RAILS_ENV=production NODE_ENV=production \
    GOROOT=/usr/lib/go GOPATH=/root/go/packages GEM_HOME=/srv/Portus/vendor/bundle/ruby/2.6.0 \
    PORTUS_KEY_PATH=ap PORTUS_SECRET_KEY_BASE=ap PORTUS_PASSWORD=ap INCLUDE_ASSETS_GROUP=yes
ENV GEM_PATH=$GEM_HOME PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$GOPATH/src/openSUSE/portusctl/bin:$GEM_HOME/bin

RUN mkdir -p "/data" "/config" 

WORKDIR $GOPATH

RUN apk add --no-cache ca-certificates git bash curl npm yarn tzdata openssl-dev \
    openldap-dev curl-dev mariadb-dev postgresql-dev make musl-dev go g++ && \
    go get github.com/tools/godep && \
    git clone https://github.com/openSUSE/portusctl.git src/openSUSE/portusctl && \
    cd src/openSUSE/portusctl && godep restore && go build -o /usr/bin/portusctl *.go && \
    cd / && rm -rf /root/go && echo "Cloning ${REPO_URL}#${REPO_TAG}" && \
    cd /srv && git clone -b "${REPO_TAG}" "${REPO_URL}" Portus && \
    cd Portus && echo "${VERSION_STRING}-$(git rev-parse --short HEAD)" > VERSION && rm -rf .git && \
    yarn install --production=false && bundle update && \
    bundle install --without test development --with assets --path ./vendor/bundle && \
    gem install bundler -v 1.17.3 -i ./vendor/bundle/ruby/2.6.0 -n ./vendor/bundle/ruby/2.6.0/bin && \
    ln -s bundler ./vendor/bundle/ruby/2.6.0/bin/bundler.ruby2.6 && \
    mkdir -p /srv/Portus/app/assets/config && touch /srv/Portus/app/assets/config/manifest.js && \
    echo "//= link_tree ../images" > /srv/Portus/app/assets/config/manifest.js && \
    echo "//= link_directory ../javascripts .js" > /srv/Portus/app/assets/config/manifest.js && \
    echo "//= link_directory ../stylesheets .css" > /srv/Portus/app/assets/config/manifest.js && \
    sed -i 's/config.assets.js_compressor = :uglifier/config.assets.js_compressor = Uglifier.new(harmony: true)/g' /srv/Portus/config/environments/production.rb && \
    ./bin/bundle exec rake portus:assets:compile && \
    rm -r ./vendor/bundle/ruby/2.6.0/cache/* && \
    rm -rf ./node_modules && \
    apk del yarn go

FROM base
LABEL MAINTAINER Casjays Development <docker-admin@casjaysdev.com> \
    version="v1.0" \
    description="Portus Dockerfile" \
    docker_image_name="casjay/portus" 

WORKDIR /root

VOLUME [ "/data", "/config", "/opt/certs" ]

COPY ./init /srv/Portus/docker/init

ENTRYPOINT ["/bin/bash", "/srv/Portus/docker/init"]
