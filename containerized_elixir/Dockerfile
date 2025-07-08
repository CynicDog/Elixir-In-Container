# --------------------
# 🏗️ Builder Stage
# --------------------
FROM hexpm/elixir:1.18.3-erlang-25.3.2.21-debian-buster-20240612-slim AS builder

WORKDIR /app

ENV MIX_ENV=prod

# Install Hex & Rebar (build tools)
RUN mix local.hex --force && mix local.rebar --force

# Fetch deps
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy app source
COPY lib ./lib

# Build release
RUN mix release

# -------------------------
# 📦 Final Runtime Stage
# -------------------------
FROM debian:buster-20240612-slim

WORKDIR /app

# Install runtime packages
RUN apt-get update -y && apt-get install -y \
    openssl \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Copy release from builder
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/containerized_elixir ./

# Use non-root user
USER nobody

# Start the app
CMD ["bin/containerized_elixir", "start"]
