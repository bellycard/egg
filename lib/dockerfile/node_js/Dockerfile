FROM node:<%= node_version %>

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD package.json $APP_HOME/
ADD yarn.lock $APP_HOME/

RUN yarn install

ADD . $APP_HOME

CMD <%= command %>