OK_COLOR=\033[32;01m
NO_COLOR=\033[0m
FOLDER=$(shell pwd)

build:
	@echo "$(OK_COLOR)==> Compiling binary$(NO_COLOR)"
	go test && go build -o bin/imaginary

test:
	go test

install:
	go get -u .

benchmark: build
	bash benchmark.sh

docker-build:
	@echo "$(OK_COLOR)==> Building Docker image$(NO_COLOR)"
	docker build --no-cache=true -t alboom/imaginary:$(VERSION) .

docker-push:
	@echo "$(OK_COLOR)==> Pushing Docker image v$(VERSION) $(NO_COLOR)"
	docker push alboom/imaginary:$(VERSION)

docker-exec:
	@echo "$(OK_COLOR)==> Access the Docker machine v$(VERSION) $(NO_COLOR)"
	docker run --rm -ti -v "${GOPATH}:/go" --entrypoint /bin/bash -p 9000:9000 -t imaginary:$(VERSION)

docker: docker-build docker-push

.PHONY: test benchmark docker-build docker-push docker
