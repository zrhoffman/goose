SHELL = /bin/bash -o pipefail

.PHONY: install test clean release

STATICCHECK := $(GOPATH)/bin/staticcheck
BUMP_VERSION := $(GOPATH)/bin/bump_version

test: lint
	go test ./...

install:
	go get -v github.com/kevinburke/goose/...

$(STATICCHECK):
	go get -u honnef.co/go/tools/cmd/staticcheck

lint: $(STATICCHECK)
	go vet ./...
	$(STATICCHECK) ./...

race-test: lint
	go test -v -race ./...

$(BUMP_VERSION):
	go get -u github.com/kevinburke/bump_version

release: race-test | $(BUMP_VERSION)
	$(BUMP_VERSION) minor cmd/goose/main.go
