FROM node:14-alpine as build

COPY . /app

WORKDIR /app

# Install dependencies
RUN yarn install --frozen-lockfile

# Build
RUN yarn rw build web && yarn rw build api


FROM node:14-alpine

WORKDIR /app

COPY .nvmrc .
COPY babel.config.js .
COPY graphql.config.js .
COPY redwood.toml .
COPY api api

# Keep the image small by only installing necessary deps to run the API server
COPY api/package.json .
RUN yarn install && yarn add react react-dom @redwoodjs/cli

COPY --from=build /app/web/dist /app/web/dist
COPY --from=build /app/api/dist /app/api/dist
COPY --from=build /app/node_modules/.prisma /app/node_modules/.prisma

EXPOSE 8911

# Entrypoint to @redwoodjs/api-server binary
CMD [ "yarn", "rw", "serve", "api", "--port", "8911", "--rootPath", "/api" ]
