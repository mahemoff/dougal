#FROM ruby:2.5.0-slim
#RUN apt-get update && apt-get upgrade -y && apt-get install -y git
FROM ruby:2.6.1-slim
RUN apt-get update
RUN apt-get install -y git build-essential

WORKDIR /dougal
ADD . /dougal
VOLUME /config
ENTRYPOINT ["bin/dougal"]

RUN bundle install
