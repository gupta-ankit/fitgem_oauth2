.PHONY: test test-ruby2 test-ruby3 build clean

test: test-ruby2 test-ruby3

test-ruby2:
	docker compose run --rm test-ruby2

test-ruby3:
	docker compose run --rm test-ruby3

build:
	docker compose build

clean:
	docker compose down --rmi local --remove-orphans
