FROM ubuntu:22.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

COPY setup_14.sh /tmp/node_setup.sh

RUN apt-get update \
    && apt-get install -y curl gnupg \
    && bash /tmp/node_setup.sh \
    && apt-get install -y nodejs git make g++ libboost-dev libboost-system-dev libboost-date-time-dev libsodium-dev

WORKDIR /xmr-node-proxy
RUN openssl req -subj "/CN=Proxy" -newkey rsa:2048 -nodes -keyout cert.key -x509 -out cert.pem -days 36500

COPY package.json .
RUN npm install

COPY . .
CMD node proxy.js
