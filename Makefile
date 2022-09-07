SHELL := /bin/bash

NAMESPACE ?= default
RELEASE_NAME ?= p4-robots
CHART_NAME ?= p4/static

DEV_CLUSTER ?= p4-development
DEV_PROJECT ?= planet-4-151612
DEV_ZONE ?= us-central1-a

PROD_CLUSTER ?= planet4-production
PROD_PROJECT ?= planet4-production
PROD_ZONE ?= us-central1-a

SED_MATCH ?= [^a-zA-Z0-9._-]
ifeq ($(CIRCLECI),true)
# Configure build variables based on CircleCI environment vars
BUILD_NUM = build-$(CIRCLE_BUILD_NUM)
COMMIT_SHA = $(shell echo ${CIRCLE_SHA1} | cut -b-7)
BRANCH_NAME ?= $(shell sed 's/$(SED_MATCH)/-/g' <<< "$(CIRCLE_BRANCH)")
BUILD_TAG ?= $(shell sed 's/$(SED_MATCH)/-/g' <<< "$(CIRCLE_TAG)")
else
# Not in CircleCI environment, try to set sane defaults
BUILD_NUM = build-local
COMMIT_SHA = build-local
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD | sed 's/$(SED_MATCH)/-/g')
BUILD_TAG ?= $(shell git tag -l --points-at HEAD | tail -n1 | sed 's/$(SED_MATCH)/-/g')
endif

# If BUILD_TAG is blank there's no tag on this commit
ifeq ($(strip $(BUILD_TAG)),)
# Default to branch name
BUILD_TAG := $(BRANCH_NAME)
else
# Consider this the new :latest image
# FIXME: implement build tests before tagging with :latest
PUSH_LATEST := true
endif

REVISION_TAG = $(shell git rev-parse --short HEAD)

lint: lint-yaml

lint-yaml:
	@find . -type f -name '*.yml' | xargs yamllint
	@find . -type f -name '*.yaml' | xargs yamllint

pull:
	docker pull gcr.io/planet-4-151612/openresty:latest

build: pull
	docker build \
		--tag=gcr.io/planet-4-151612/robots:$(BUILD_TAG) \
		--tag=gcr.io/planet-4-151612/robots:$(COMMIT_SHA) \
		--tag=gcr.io/planet-4-151612/robots:$(REVISION_TAG) \
		.

push: push-tag push-latest

push-tag:
	docker push gcr.io/planet-4-151612/robots:$(BUILD_TAG)
	docker push gcr.io/planet-4-151612/robots:$(COMMIT_SHA)

push-latest:
	@if [[ "$(PUSH_LATEST)" = "true" ]]; then { \
		docker tag gcr.io/planet-4-151612/robots:$(REVISION_TAG) gcr.io/planet-4-151612/robots:latest; \
		docker push gcr.io/planet-4-151612/robots:latest; \
	}	else { \
		echo "Not tagged.. skipping latest"; \
	} fi

dev:
	gcloud config set project $(DEV_PROJECT)
	gcloud container clusters get-credentials $(DEV_CLUSTER) --zone $(DEV_ZONE) --project $(DEV_PROJECT)
	helm3 plugin install https://github.com/helm/helm-2to3.git || true
	helm3 2to3 convert "${RELEASE_NAME}" || true

	helm3 repo add p4 https://planet4-helm-charts.storage.googleapis.com && \
	helm3 repo update
	helm3 upgrade --install --force --wait --timeout 300s $(RELEASE_NAME) $(CHART_NAME) \
		--version="0.5.1-alpha" \
		--namespace=$(NAMESPACE) \
		--set image.tag=$(COMMIT_SHA) \
		--values values.yaml \
		--values env/dev/values.yaml \
		--set openresty.geoip.accountid=$(GEOIP_ACCOUNTID) \
		--set openresty.geoip.license=$(GEOIP_LICENSE)

prod:
	gcloud config set project $(PROD_PROJECT)
	gcloud container clusters get-credentials $(PROD_CLUSTER) --zone $(PROD_ZONE) --project $(PROD_PROJECT)
	helm3 plugin install https://github.com/helm/helm-2to3.git || true
	helm3 2to3 convert "${RELEASE_NAME}" || true

	helm3 repo add p4 https://planet4-helm-charts.storage.googleapis.com && \
	helm3 repo update
	helm3 upgrade --install --force --wait --timeout 300s $(RELEASE_NAME) $(CHART_NAME) \
		--namespace=$(NAMESPACE) \
		--set image.tag=$(COMMIT_SHA) \
		--values values.yaml \
		--values env/prod/values.yaml \
		--set openresty.geoip.accountid=$(GEOIP_ACCOUNTID) \
		--set openresty.geoip.license=$(GEOIP_LICENSE)


history:
	helm history $(RELEASE_NAME) --max=5
