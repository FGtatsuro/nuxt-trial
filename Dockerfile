FROM node:latest

RUN mkdir -p /workdir/pages
COPY package.json package-lock.json /workdir
COPY nuxt.config.ts /workdir
COPY pages /workdir/pages

WORKDIR /workdir
RUN npm install

ENTRYPOINT ["npx"]
