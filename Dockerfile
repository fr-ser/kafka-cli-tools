FROM openjdk:14-jdk-alpine3.10
LABEL MAINTAINER="Sergej Herbert <herbert.sergej@gmail.com>"

ENV KAFKA_VERSION=2.4.0
ENV KAFKA_URL=http://mirror.dkd.de/apache/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz
ENV KAFKA_TMP_DEST=/cli/kafka.tgz
ENV KAFKA_WORKDIR=/cli/kafka
ENV PATH=$PATH:/cli/kafka/bin

RUN apk update && apk upgrade && apk add bash

RUN mkdir -p ${KAFKA_WORKDIR}
RUN wget $KAFKA_URL -O ${KAFKA_TMP_DEST} && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR} && \
    rm ${KAFKA_TMP_DEST}

WORKDIR /cli

ADD create_topics.sh ./

CMD [ "/cli/create_topics.sh" ]
