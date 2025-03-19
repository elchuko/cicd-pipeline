FROM node:23-alpine3.20
WORKDIR /opt
ADD . /opt
EXPOSE 3000
RUN npm install
ENTRYPOINT npm start