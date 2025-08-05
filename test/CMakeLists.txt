add_executable(fsalloc fsalloc.c)

target_include_directories(fsalloc PRIVATE ../include)
target_link_libraries(fsalloc aLocas)

add_test(NAME fsalloc COMMAND fsalloc)