FROM openjdk:8u212-jre-alpine
LABEL MAINTAINER="Sergej Herbert <herbert.sergej@gmail.com>"

RUN apk update && apk upgrade && apk add bash curl jq

ARG KAFKA_VERSION_ARG=2.6.0
ENV KAFKA_VERSION=${KAFKA_VERSION_ARG}
ARG SCALA_VERSION_ARG=2.12
ENV SCALA_VERSION=${SCALA_VERSION_ARG}
ENV KAFKA_TMP_DEST=/cli/kafka.tgz
ENV KAFKA_WORKDIR=/cli/kafka
ENV PATH=$PATH:/cli/kafka/bin

RUN mkdir -p ${KAFKA_WORKDIR}

COPY download_kafka.sh /tmp/
RUN /tmp/download_kafka.sh && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR} && \
    rm ${KAFKA_TMP_DEST}

WORKDIR /cli/kafka

COPY create_topics.sh /cli/
COPY entrypoint.sh /cli/

ENTRYPOINT [ "/cli/entrypoint.sh" ]
