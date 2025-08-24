cflags := -Wall -std=c17 -Iinclude

init:
	mkdir -p build
	mkdir -p build/test
	mkdir -p build/shared
	mkdir -p install
	python3 tools/pec/pec.py .ec include/ec.h _LJW_ALOCAS_EC_H_

build: build/libaLocas.a build/libaLocas.so
tbuild: build/test/fsalloc
test: build/test/fsalloc
	./$<
install: build/libaLocas.a build/libaLocas.so
	mkdir -p install/include
	cp -r include/* install/include/
	cp $^ install/
	cd install && zip -r aLocas.zip include/ *.a *.so

build/libaLocas.a: build/fsalloc.o
	${AR} rcs $@ $^
build/libaLocas.so: build/shared/fsalloc.o
	${CC} -shared $^ -o $@

build/%.o: src/%.c
	${CC} ${cflags} -c $< -o $@
build/shared/%.o: src/%.c
	${CC} ${cflags} -fPIC -c $< -o $@

clean:
	rm -rf build

.PHONY: init build tbuild test install clean