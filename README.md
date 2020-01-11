# kafka-cli-tools

[![Docker Pulls](https://img.shields.io/docker/pulls/frser/kafka-cli.svg)](https://hub.docker.com/r/frser/kafka-cli/)

docker image with kafka cli tools

# Usage example:

See docker-compose [file](docker-compose.yaml) in [Github](https://github.com/fr-ser/kafka-cli-tools)

## Topic creation:

This CLI can also create topics via environment configuration. Below are example environment
variables to create two topics:

```bash
BOOTSTRAP_SERVER="kafka:29092"
CREATE_TOPICS="test.telemetry.readings:3:1,test.telemetry.alarms"
```
