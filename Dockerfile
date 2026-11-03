# syntax=docker/dockerfile:1
# The toolchain the component runs in every stage. The code is not in the image: staging and production build the
# deployment's commit on its own machine, development runs the working copy.
FROM node:24-slim

# su-exec (gosu here) drops to uid 1000 after the work that needs root, and curl lets a build wait for the components
# it depends on
RUN apt-get update \
    && apt-get install -y --no-install-recommends gosu curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s "$(command -v gosu)" /usr/local/bin/su-exec

# Enable corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Setup PNPM
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PNPM_HOME/bin:$PATH"
RUN mkdir -p /home/codespace/.pnpm-store /pnpm \
    && chown -R 1000:1000 /home/codespace/.pnpm-store /pnpm

COPY --from=oven/bun:1.4.4 /usr/local/bin/bun /usr/local/bin/bun

# Serves the build in staging and production
RUN npm i -g serve

# Apply PNPM settings to be consistent with devcontainer
ENV NODE_ENV=development
ENV CI=true
ENV PNPM_CONFIG_NODE_LINKER=hoisted
ENV PNPM_CONFIG_MINIMUM_RELEASE_AGE=0
ENV PNPM_CONFIG_STRICT_DEP_BUILDS=false
ENV PNPM_CONFIG_CONFIRM_MODULES_PURGE=false
USER 1000:1000
RUN pnpm config set store-dir /home/codespace/.pnpm-store --global
USER root

# The project's initScript (diploi.yaml) runs as root before the app, which then runs as uid 1000. A container that
# starts as uid 1000 (development) runs the app as it is
COPY --chmod=755 <<'SCRIPT' /usr/local/bin/diploi-entrypoint
#!/bin/sh
set -e
if [ "$(id -u)" = "0" ]; then
  if [ -n "${DIPLOI_INIT_SCRIPT:-}" ]; then sh -c "$DIPLOI_INIT_SCRIPT"; fi
  exec su-exec 1000:1000 "$@"
fi
exec "$@"
SCRIPT
ENTRYPOINT ["diploi-entrypoint"]

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
