# kafka-cli-tools

[![Docker Pulls](https://img.shields.io/docker/pulls/frser/kafka-cli.svg)](https://hub.docker.com/r/frser/kafka-cli/)

[docker image with kafka cli tools](https://hub.docker.com/r/frser/kafka-cli/)

## Appreciation and reason for existence

This project owes all of its inspiration and most of the code to:
https://github.com/wurstmeister/kafka-docker/

The reason for this repo next to wurstmeister is to allow using different kafka sources (e.g.
confluent) and still being able to use topic creation through containers.

## Usage example

**Caveat**: As the CLI tools run **inside** docker, the container needs to be able to access
Kafka from there. This is usually done by spawning the container in the same docker-compose file
or by attaching the container to the same docker network Kafka is in.

For a full example see: [file](docker-compose.yaml) in
[Github](https://github.com/fr-ser/kafka-cli-tools/blob/master/docker-compose.yaml)

The following examples will be based on this configuration:

```yaml
# docker-compose.yaml
kafka-cli:
  image: frser/kafka-cli
  environment:
    BOOTSTRAP_SERVER: kafka:9092
    CREATE_TOPICS: >-
      readings:3:1:compact,
      alarms:2:1,
      errors,
```

### Topic creation

This CLI can also create topics via environment configuration. Below are example environment
variables to create two topics:

The configuration can be a simple comma separated list
`CREATE_TOPICS=readings:3:1:compact,alarms:2:1,telemetry.errors`.

A neat way to represent it in yaml is with the multi line syntax:

```yaml
CREATE_TOPICS: >-
  readings:3:1:compact,
  alarms:2:1,
  errors,

# the trailing comma is just for easier copy-pasting
```

```sh
docker-compose run --rm kafka-cli
```

### Waiting for kafka

```sh
docker-compose run --rm kafka-cli
```

### Executing a one off command

```sh
docker-compose run --rm -e CREATE_TOPICS="" -e START_TIMEOUT=20 kafka-cli kafka-topics.sh --list --bootstrap-server kafka:9092
```
