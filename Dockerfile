# syntax=docker/dockerfile:1
FROM ruby:3.2.2-slim AS base

WORKDIR /rails

# Install essential packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Build stage
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code and precompile bootsnap
COPY . .
RUN bundle exec bootsnap precompile app/ lib/

# Final stage
FROM base

# Copy artifacts from build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Setup user and permissions
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /rails/db/sqlite3 && \
    chown -R rails:rails /rails

# Switch to rails user and setup database
USER 1000:1000
RUN RAILS_ENV=production ./bin/rails db:create && \
    RAILS_ENV=production ./bin/rails db:schema:load && \
    RAILS_ENV=production ./bin/rails db:migrate

EXPOSE 80
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]
