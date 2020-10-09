Feature: Kafka CLI

    Scenario: Wait for Kafka
        Given we start Kafka and Zookeeper
        And Kafka is not reachable
        When we run the kafka-cli and wait for it
        Then we expect Kafka to be reachable

    Scenario: Create topics
        When we run the kafka-cli with the environment below and wait for it
            | key           | value                                   |
            | CREATE_TOPICS | readings:3:1:compact,alarms:2:1,errors, |
        Then we expect the following topics to exist in Kafka
            | topics   |
            | readings |
            | alarms   |
            | errors   |

    Scenario: Run command
        When we run the kafka-cli with the command "kafka-topics.sh --version" and store the output
        Then we expect the stored output to contain the current Kafka version
