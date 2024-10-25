# this tells Make to run 'make help' if the user runs 'make'
# without this, Make would use the first target as the default
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check-hostname:
ifndef HOSTNAME
	$(error ERROR: Required environment variable HOSTNAME is undefined)
endif

check-domain:
ifndef DOMAIN
	$(error ERROR: Required environment variable DOMAIN is undefined)
endif

clean: ## clean dist
	rm -rf dist

build: clean ## build dist
	npm run build

publish: check-hostname check-domain ## publish dist
	rsync -rvzP ./dist/ "${HOSTNAME}":"/var/www/${DOMAIN}/html/"

build-publish: build publish ## build and publish dist
