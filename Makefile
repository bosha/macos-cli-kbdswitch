SCRIPT_NAME = kbdswitch
BIN_DIR = ~/bin
TARGET = $(BIN_DIR)/$(SCRIPT_NAME)

all: compile move

compile:
	@echo "Compiling $(SCRIPT_NAME).swift..."
	@swiftc $(SCRIPT_NAME).swift -o $(SCRIPT_NAME)
	@echo "Compilation complete. Binary created: ./$(SCRIPT_NAME)"

move:
	@if [ -d $(BIN_DIR) ]; then \
		echo "Moving $(SCRIPT_NAME) to $(BIN_DIR)..."; \
		mv $(SCRIPT_NAME) $(BIN_DIR); \
		echo "Binary moved to $(BIN_DIR)/$(SCRIPT_NAME)"; \
	else \
		echo "Directory $(BIN_DIR) does not exist."; \
		read -p "Create $(BIN_DIR) and move the binary there? (y/n): " confirm; \
		if [ "$$confirm" = "y" ]; then \
			mkdir -p $(BIN_DIR); \
			echo "Directory $(BIN_DIR) created."; \
			mv $(SCRIPT_NAME) $(BIN_DIR); \
			echo "Binary moved to $(BIN_DIR)/$(SCRIPT_NAME)"; \
		else \
			echo "Operation canceled. Binary remains in the current directory."; \
		fi; \
	fi

all: compile move

clean:
	@if [ -f $(SCRIPT_NAME) ]; then \
		rm $(SCRIPT_NAME); \
		echo "Removed $(SCRIPT_NAME) from the current directory."; \
	else \
		echo "No binary to remove in the current directory."; \
	fi
	@if [ -f $(TARGET) ]; then \
		rm $(TARGET); \
		echo "Removed $(TARGET) from $(BIN_DIR)."; \
	else \
		echo "No binary to remove in $(BIN_DIR)."; \
	fi

.PHONY: compile move all clean
