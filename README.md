# kafka-cli-tools

docker image with kafka cli tools

# Usage example:

```yaml
version: "3.6"

services:
  kafka:
    image: spotify/kafka
    ports:
      - "9092:9092"
      - "2181:2181"
    environment:
      ADVERTISED_HOST: kafka
      ADVERTISED_PORT: 9092
      TOPICS: readings
    producer:
      image: frser/kafka-cli:2.3.0
      command: kafka-console-producer.sh --broker-list kafka:9092 --topic readings
      links:
        - kafka
    consumer:
      image: frser/kafka-cli:2.3.0
      command: kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic readings --from-beginning
```
