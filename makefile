.PHONY: clean

BUILD_DIR=build

default: foopak

src/main.sh: src/[^main]*.sh

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

foopak: src/main.sh $(BUILD_DIR)
	./bashminify.sh src/main.sh > build/foopak
	chmod +x build/foopak

clean:
	rm -rf build

