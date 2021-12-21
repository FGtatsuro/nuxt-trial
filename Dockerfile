FROM node:latest

RUN mkdir -p /workdir/pages /workdir/types
COPY package.json package-lock.json /workdir
COPY tsconfig.json /workdir
COPY nuxt.config.ts /workdir
COPY .eslintrc.js /workdir
COPY .stylelintrc.js /workdir
COPY pages /workdir/pages
COPY types /workdir/types

WORKDIR /workdir
RUN npm install

ENTRYPOINT ["npx"]
