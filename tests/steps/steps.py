import os
from logging import NullHandler
import subprocess

from behave import given, when, then
from confluent_kafka import Producer

KAFKA_VERSION = os.environ.get("KAFKA_VERSION", "2.6.0")
KAFKA_HOST = "localhost"
KAFKA_PORT = "39092"
kafka_client = Producer({"bootstrap.servers": f"{KAFKA_HOST}:{KAFKA_PORT}", "logger": NullHandler})

docker_compose_cmd = "docker-compose -f tests/docker-compose.test.yaml"


@given(u'we start Kafka and Zookeeper')
def start_kafka_step(context):
    subprocess.run(
        f"{docker_compose_cmd} up --detach kafka zookeeper",
        shell=True, check=True, stdout=subprocess.DEVNULL,
    )


@given(u'Kafka is not reachable')
def kafka_unreachable_step(context):
    try:
        kafka_client.list_topics(timeout=1)
    except Exception:
        pass
    else:
        raise AssertionError("Kafka was reachable")


@when(u'we run the kafka-cli and wait for it')
def run_cli_step(context):
    subprocess.run(
        f"{docker_compose_cmd} run --rm kafka-cli",
        shell=True, check=True, stdout=subprocess.DEVNULL,
    )


@when(u'we run the kafka-cli with the environment below and wait for it')
def run_cli_with_env_step(context):
    env_string = " ".join(f'-e {row["key"]}={row["value"]}' for row in context.table)
    subprocess.run(
        f"{docker_compose_cmd} run --rm {env_string} kafka-cli",
        shell=True, check=True, stdout=subprocess.DEVNULL,
    )


@when(u'we run the kafka-cli with the command "{command}" and store the output')
def run_cli_with_command_step(context, command):
    context.output = str(
        subprocess.check_output(
            f"{docker_compose_cmd} run --rm kafka-cli {command}",
            shell=True,
        )
    )


@then(u'we expect Kafka to be reachable')
def kafka_reachable_step(context):
    try:
        kafka_client.list_topics(timeout=5)
    except Exception as exc:
        raise AssertionError(f"Kafka was not reachable: {exc}")


@then(u'we expect the following topics to exist in Kafka')
def check_topics_step(context):
    got = set(kafka_client.list_topics(timeout=3).topics.keys())
    expected = set(row["topics"] for row in context.table)

    assert got == expected, f"got: {got} - expected: {expected}"


@then(u'we expect the stored output to contain the current Kafka version')
def check_version_step(context):
    assert KAFKA_VERSION in context.output, f"Did not find '{KAFKA_VERSION}' in {context.output}"
