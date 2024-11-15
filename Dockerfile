FROM ruby:3.3.6-slim
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
WORKDIR /rails
RUN apt-get update; \
    apt-get install -y curl; \
    curl -sL https://deb.nodesource.com/setup_20.x | bash -; \
    curl -Ss https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libjemalloc2 libvips postgresql-client libpq-dev git pkg-config nodejs yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

