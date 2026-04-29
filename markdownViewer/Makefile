.PHONY: build clean build-amd64 build-arm64

BIN_DIR := bin
CMD_DIR := cmd/dms-lister

build: build-amd64 build-arm64

build-amd64:
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=amd64 go build -o $(BIN_DIR)/dms-lister-amd64 ./$(CMD_DIR)
	@echo "Built amd64 binary: $(BIN_DIR)/dms-lister-amd64"

build-arm64:
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=arm64 go build -o $(BIN_DIR)/dms-lister-arm64 ./$(CMD_DIR)
	@echo "Built arm64 binary: $(BIN_DIR)/dms-lister-arm64"

clean:
	rm -rf $(BIN_DIR)

test:
	@echo "Testing amd64 build..."
	go build -o /tmp/test-amd64 ./$(CMD_DIR)
	/tmp/test-amd64 $(HOME)
	rm /tmp/test-amd64
