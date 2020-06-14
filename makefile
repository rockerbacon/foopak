BUILD_DIR=build

.PHONY: clean

default: $(BUILD_DIR)/foopak

src/main.sh: src/[^main]*.sh

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/foopak: src/main.sh $(BUILD_DIR)
	./bashminify.sh src/main.sh > $(BUILD_DIR)/foopak
	chmod +x build/foopak

clean:
	rm -rf build

