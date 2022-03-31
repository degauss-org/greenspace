.PHONY: build test shell clean

build:
	docker build -t greenspace .

test:
	docker run --rm -v "${PWD}/test":/tmp greenspace my_address_file_geocoded.csv

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp greenspace

clean:
	docker system prune -f