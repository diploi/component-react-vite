# This will be set by the GitHub action to the folder containing this component.
ARG FOLDER=/app

# This will be set by the GitHub action if "__VITE_RUNTIME_BUILD" ENV is set in diploi.yaml
ARG __VITE_RUNTIME_BUILD=false

FROM node:24-slim AS base

# Enable corepack
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

# Setup PNPM
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Install dependencies only when needed
FROM base AS deps
ARG FOLDER

COPY . /app
WORKDIR ${FOLDER}

# Install dependencies based on the preferred package manager
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
ARG FOLDER
COPY . /app
WORKDIR ${FOLDER}
COPY --from=deps ${FOLDER}/node_modules ./node_modules

RUN \
  if [ -f yarn.lock ]; then yarn run build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

# When "__VITE_RUNTIME_BUILD" is false, only ship the built assets.
FROM base AS runner-false
ARG FOLDER
COPY --from=builder --chown=1000:1000 ${FOLDER}/dist ${FOLDER}/dist

# When "__VITE_RUNTIME_BUILD" is true, include entire app code. Build will be run again in an init-container.
FROM base AS runner-true
ARG FOLDER
COPY --from=builder --chown=1000:1000 /app /app

FROM runner-${__VITE_RUNTIME_BUILD} AS runner
ARG FOLDER

WORKDIR ${FOLDER}

ENV NODE_ENV=production

USER 1000:1000

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
RUN npm i -g serve

EXPOSE 5173
ENV PORT=5173
ENV HOSTNAME="0.0.0.0"

CMD ["serve", "-s", "-l", "5173", "dist"]
