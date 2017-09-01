FROM node:6

ENV VER=${VER:-master} \
    REPO=https://github.com/twhtanghk/vncproxy \
    APP=/usr/src/app

RUN apt-get update \
&&  apt-get install -y git \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* \
&&  git clone -b $VER $REPO $APP

WORKDIR $APP

EXPOSE 1337

CMD npm start
