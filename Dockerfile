FROM node:23-alpine3.20
WORKDIR /opt
ADD . /opt
RUN npm install
EXPOSE 3001
ENTRYPOINT npm start