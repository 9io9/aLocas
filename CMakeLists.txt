cmake_minimum_required(VERSION 3.25.1)

project(aLocas VERSION 0.0.1 LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE Debug)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/include/ec.h 
    COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/tools/pec/pec.py ${CMAKE_CURRENT_SOURCE_DIR}/.ec ${CMAKE_CURRENT_SOURCE_DIR}/include/ec.h _LJW_ALOCAS_EC_H_
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/.ec ${CMAKE_CURRENT_SOURCE_DIR}/tools/pec/pec.py
    COMMENT "convert .ec to error code header file"
)

add_custom_target(alogech DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/ec.h)

add_library(aLocas STATIC src/fsalloc.c)
add_dependencies(aLocas alogech)

target_include_directories(aLocas PRIVATE include)

enable_testing()
add_subdirectory(test)