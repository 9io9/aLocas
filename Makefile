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
	./build/test/fsalloc
install: build/libaLocas.a build/libaLocas.so
	mkdir -p install/include
	cp -r include/* install/include/
	cp $^ install/
	cp .sym install/
	cd install && zip -r aLocas.zip include/ *.a *.so .sym

build/libaLocas.a: build/fsalloc.o
	${AR} rcs $@ $^
build/libaLocas.so: build/shared/fsalloc.o
	${CC} -shared $^ -o $@

build/test/fsalloc: test/fsalloc.c build/libaLocas.a
	${CC} ${cflags} $^ -o $@

build/%.o: src/%.c
	${CC} ${cflags} -c $< -o $@
	nm -g $@ | awk '{print $$3}' >> .sym
build/shared/%.o: src/%.c
	${CC} ${cflags} -fPIC -c $< -o $@

clean:
	rm -rf build
	rm .sym

.PHONY: init build tbuild test install clean