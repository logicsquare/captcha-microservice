# docker build -t captcha-microservice .
FROM node:alpine

WORKDIR /usr/src/app

COPY . .

RUN npm install

EXPOSE 9090

ENV NODE_ENV "production"
ENV PORT "9090"
ENV REDIS_CONNECT_STRING ""
ENV REDIS_NAMESPACE "captcha"
ENV REQUIRE_AUTH "no"
ENV ACCESS_TOKEN "xxxxyyyyzzzz"

CMD ["npm", "run", "start"]
