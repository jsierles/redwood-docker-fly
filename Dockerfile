FROM node:14-alpine as web

# Node
ARG NODE_ENV
ARG RUNTIME_ENV
ENV NODE_ENV=$NODE_ENV
ENV RUNTIME_ENV=$RUNTIME_ENV

# Set workdir
WORKDIR /app

COPY web web
COPY .nvmrc .
COPY babel.config.js .
COPY graphql.config.js .
COPY package.json .
COPY redwood.toml .
COPY yarn.lock .

# Install dependencies
RUN yarn install --frozen-lockfile

# Build
RUN yarn rw build web

# Clean up
RUN rm -rf ./web/src

FROM node:14-alpine

# Node
ARG NODE_ENV
ARG RUNTIME_ENV
ENV NODE_ENV=$NODE_ENV
ENV RUNTIME_ENV=$RUNTIME_ENV
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Set workdir
WORKDIR /app

COPY api api
COPY .nvmrc .
COPY babel.config.js .
COPY graphql.config.js .
COPY package.json .
COPY redwood.toml .
COPY yarn.lock .

# Install dependencies
RUN yarn install --frozen-lockfile

RUN yarn add -W react react-dom
# Build
RUN yarn rw build api

# Migrate database
# This has been commented out in this example post
# RUN yarn rw prisma migrate deploy

# Seed database
# This has been commented out in this example post
# RUN yarn rw prisma db seed

# Clean up
RUN rm -rf ./api/src

COPY --from=web /app/web/dist /app/public

# Set api as workdirectory
WORKDIR /app/api

# Expose RedwoodJS api port
EXPOSE 8911

# Entrypoint to @redwoodjs/api-server binary
ENTRYPOINT [ "yarn", "rw", "serve", "api", "--port", "8911", "--rootPath", "/api" ]
