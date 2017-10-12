FROM node

ENV APP=/usr/src/app

ADD . $APP

WORKDIR $APP

RUN npm install

EXPOSE 1337

ENTRYPOINT ["node", "app.js", "--prod"]
