NAME = ghanique/payment-haskell
INSTANCE = payment

.PHONY: default build copy base

default: build

base:
	docker build -t $(NAME)-base -f ./docker/payment/Dockerfile-base .

build:
	docker build -t $(NAME)-dev -f ./docker/payment/Dockerfile .

copy:
	docker create --name $(INSTANCE) $(NAME)-dev
	docker cp $(INSTANCE):/app/main $(shell pwd)/app
	docker rm $(INSTANCE)

release:
	docker build -t $(NAME) -f ./docker/payment/Dockerfile-release .

run:
	docker run --name dev -p 8080:8080 -d $(NAME)-dev
