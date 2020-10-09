FROM openjdk:8u212-jre-alpine
LABEL MAINTAINER="Sergej Herbert <herbert.sergej@gmail.com>"

ARG KAFKA_VERSION=2.6.0
ARG SCALA_VERSION=2.13
ENV KAFKA_TMP_DEST=/cli/kafka.tgz
ENV KAFKA_WORKDIR=/cli/kafka
ENV PATH=$PATH:/cli/kafka/bin

RUN apk update && apk upgrade && apk add bash curl jq
RUN mkdir -p ${KAFKA_WORKDIR}

COPY download_kafka.sh /tmp/
RUN /tmp/download_kafka.sh && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR} && \
    rm ${KAFKA_TMP_DEST}

WORKDIR /cli/kafka

COPY create_topics.sh /cli/
COPY entrypoint.sh /cli/

ENTRYPOINT [ "/cli/entrypoint.sh" ]
