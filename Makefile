SHELL = /bin/bash
package = shagen/example-jsbsim

.DEFAULT_GOAL := all

.PHONY: clean
clean:
	@rm -rf build
	@echo [example-jsbsim] cleansing complete

.PHONY: init
init: clean
	@cmake -DCMAKE_BUILD_TYPE=Release -GNinja -S . -B build
	@echo [example-jsbsim] setup of build generators complete

.PHONY: build
build:
	@cmake --build build -t example
	@echo [example-jsbsim] build of implementation complete

.PHONY: test
test: build
	@echo [example-jsbsim] starting test runs ...
	@echo [example-jsbsim] test runs complete

.PHONY: all
all: init build test

.PHONY: name
name:
	@printf "Revision.is(): sha1:%s\n" "$$(git rev-parse HEAD)"
	@printf "Name.derive(): '%s'\n" "$$(git-release-name "$$(git rev-parse HEAD)")"
