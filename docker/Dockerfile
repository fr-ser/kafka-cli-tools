FROM openjdk:14-jdk-alpine3.10
LABEL MAINTAINER="Sergej Herbert <herbert.sergej@gmail.com>"

ARG KAFKA_VERSION=2.6.0
ARG SCALA_VERSION=2.13
ARG KAFKA_URL=http://mirror.dkd.de/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
ENV KAFKA_TMP_DEST=/cli/kafka.tgz
ENV KAFKA_WORKDIR=/cli/kafka
ENV PATH=$PATH:/cli/kafka/bin

RUN apk update && apk upgrade && apk add bash

RUN mkdir -p ${KAFKA_WORKDIR}
RUN wget $KAFKA_URL -O ${KAFKA_TMP_DEST} && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR} && \
    rm ${KAFKA_TMP_DEST}

WORKDIR /cli/kafka

COPY create_topics.sh /cli/
COPY entrypoint.sh /cli/

ENTRYPOINT [ "/cli/entrypoint.sh" ]
