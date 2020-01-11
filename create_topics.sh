#!/bin/bash

# Incredibly heavily inspired by wurstmeister's solution
# https://github.com/wurstmeister/kafka-docker/blob/master/start-kafka.sh

if [[ -z "$CREATE_TOPICS" ]]; then
    exit 0
fi


if [[ -z "$BOOTSTRAP_SERVER" ]]; then
    echo "Missing required environment variable: BOOTSTRAP_SERVER (e.g. 'kafka:9092')"
fi

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10

until nc -z ${BOOTSTRAP_SERVER}; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$((count + step))
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Not able to auto-create topic (waited for $START_TIMEOUT sec)"
    exit 1
fi

# Expected format:
#   name:[partitions[:replicas]]
IFS=","; for topicToCreate in $CREATE_TOPICS; do
    echo "creating topic: $topicToCreate"
    IFS=':' read -r -a topicConfig <<< "$topicToCreate"
    trimmed_name="$(echo -e "${topicConfig[0]}" | sed -e 's/^[[:space:]]*//')"

    kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVER} \
		--topic ${trimmed_name} \
		--partitions ${topicConfig[1]:-1} \
		--replication-factor ${topicConfig[2]:-1} &
done

wait