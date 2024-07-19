FROM node:22-alpine3.19 AS builder

WORKDIR /build
COPY . /build/
RUN corepack enable
RUN yarn install --immutable
RUN yarn build

FROM node:22-alpine3.19 AS runner

COPY --from=builder /build/dist /usr/local/bin/appeals
HEALTHCHECK  --interval=10s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:$PORT/ || exit 1
CMD [ "node", "/usr/local/bin/appeals/server/entry.mjs" ]