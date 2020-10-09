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
