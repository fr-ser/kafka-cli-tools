teardown:
	docker-compose down --volumes --remove-orphans --timeout 5

start: teardown
	docker-compose build
	docker-compose run --rm kafka-cli
