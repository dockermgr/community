FROM ruby:2.7 as build

LABEL maintainer="docker-admin@casjaysdev.com"

VOLUME /site

EXPOSE 4000

WORKDIR /site

RUN gem install github-pages jekyll-assets jekyll-include-cache activesupport rake mini_portile2 minitest \
      racc zeitwerk rexml ffi sprockets listen jekyll && gem install casjaysdev-jekyll-theme

FROM build as jekyll

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 4000

VOLUME /site
WORKDIR /site

# on every container start, check if Gemfile exists and warn if it's missing
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

