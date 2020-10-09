install:
	python -m pipenv install --dev

teardown:
	docker-compose down --volumes --remove-orphans --timeout 5

start: teardown
	docker-compose build
	docker-compose run --rm kafka-cli

bootstrap-test:
	docker-compose -f tests/docker-compose.test.yaml down --volumes --remove-orphans --timeout 5 > /dev/null
	docker-compose -f tests/docker-compose.test.yaml pull > /dev/null
	docker-compose -f tests/docker-compose.test.yaml build > /dev/null

test-without-bootstrap:
	@echo
	@echo
	python -m pipenv run behave tests -q
	@echo
	@echo


test: bootstrap-test test-without-bootstrap
	docker-compose -f tests/docker-compose.test.yaml down --volumes --remove-orphans --timeout 5 > /dev/null

build-and-push:
	docker build --build-arg KAFKA_VERSION_ARG=$${KAFKA_VERSION:-2.6.0} \
		 --build-arg SCALA_VERSION_ARG=$${SCALA_VERSION:-2.12} \
		-t frser/kafka-cli:$${DOCKER_TAG:-$$SCALA_VERSION-$$KAFKA_VERSION} \
		./docker
	docker push frser/kafka-cli:$${DOCKER_TAG:-$$SCALA_VERSION-$$KAFKA_VERSION}
