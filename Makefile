# include Makefile.*

#!make
IMAGE_NAME="dummy-python-api"
IMAGE_REPOSITORY ?=my-awesome-repository
IMAGE_TAG ?= $(shell git rev-parse --short=7 HEAD)
VERSION_TAG ?= $(git describe --tags --abbrev=0)
FOLDER_PROJECT = app
VENV = .venv
PYTHON = $(VENV)/bin/python3
PIP = $(VENV)/bin/pip
AUTOPEP8 = $(PYTHON) -m autopep8
ISORT = $(PYTHON) -m isort
PYLINT = $(PYTHON) -m pylint
BANDIT = $(PYTHON) -m bandit

.PHONY: up
up:
	docker compose up

.PHONY: down
down:
	docker compose down

.PHONY: clean
clean:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' | xargs rm -rf
	find . -type d -name '*.ropeproject' | xargs rm -rf
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg*
	rm -rf docs/build/
	rm -f MANIFEST
	rm -f .coverage.*
	rm -rf htmlcov
	# rm -rf "$(VENV)"

.PHONY: autoflake
autoflake:
	poetry run autoflake --in-place \
    --expand-star-imports \
    --remove-duplicate-keys \
    --remove-unused-variables \
		app/*.py

.PHONY: autopep8
autopep8: 
	$(AUTOPEP8) --in-place $(FOLDER_PROJECT)/*.py $(args)

.PHONY: code-review
code-review:
  
	$(MAKE) autopep8

.PHONY: docker-tag
docker-tag:
	docker tag ${IMAGE_REPOSITORY} ${IMAGE_REPOSITORY}:${IMAGE_TAG}
	docker tag ${IMAGE_REPOSITORY} ${IMAGE_REPOSITORY}:latest

ifneq ($(VERSION_TAG),)
	docker tag ${IMAGE_REPOSITORY} ${IMAGE_REPOSITORY}:${VERSION_TAG}
endif

.PHONY: docker-push
docker-push:
	docker push ${IMAGE_REPOSITORY}:${IMAGE_TAG}
	docker push ${IMAGE_REPOSITORY}:latest

ifneq ($(VERSION_TAG),)
	docker push ${IMAGE_REPOSITORY}:${VERSION_TAG}
endif

.PHONY: docker-build
docker-build:
	# We should uncomment this once we got the first image pushed: docker pull ${IMAGE_REPOSITORY}:latest || true

	# docker build --cache-from ${IMAGE_REPOSITORY}:latest -t ${IMAGE_REPOSITORY} .
	docker build -t ${IMAGE_NAME} .

.PHONY: docker-run
docker-run:
	docker run --rm -p 5000:5000 ${IMAGE_NAME}

.PHONY: run
run:
	poetry run python app/main.py
	
.PHONY: run-local
run-local:
	poetry run python app/main.py --debug --no-reload

.PHONY: deps
deps:
	poetry install

