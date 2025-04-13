SHELL := /bin/bash

include Makefile.variables

prepare: tmp/dev_image_id
tmp/dev_image_id:
	@mkdir -p tmp
	@docker rmi -f ${DEV_IMAGE} > /dev/null 2>&1 || true
	@docker build -t ${DEV_IMAGE} -f Dockerfile.dev .
	@docker inspect -f "{{ .ID }}" ${DEV_IMAGE} > tmp/dev_image_id

vendor: tmp/vendor-installed
tmp/vendor-installed: tmp/dev_image_id go.mod
	@mkdir -p vendor
	${DOCKERRUN} GOSUMDB=off go mod tidy
	${DOCKERRUN} GOSUMDB=off go mod vendor
	@date > tmp/vendor-installed
	@chmod 644 go.sum || :

clean:
	@rm -rf tmp bin

codegen:
	${DOCKRUN} bash ./scripts/swagger.sh

build:
	@bash ./scripts/build.sh

# Display help
help:
	@echo "Usage:"
	@echo "  make         - Build the project"
	@echo "  make build   - Build the project"
	@echo "  make test    - Run tests"
	@echo "  make clean   - Clean the build directory"
	@echo "  make install - Install the application"
	@echo "  make run     - Build and run the application"
	@echo "  make gen     - Generate Swagger code"
	@echo "  make help    - Display this help message"
