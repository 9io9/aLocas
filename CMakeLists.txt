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

set_target_properties(aLocas PROPERTIES EXPORT_NAME aLocas)

install(
    TARGETS aLocas
    EXPORT aLocasTargets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
install(DIRECTORY include DESTINATION .)
install(
    EXPORT aLocasTargets
    FILE aLocasTargets.cmake
    NAMESPACE aLocas::
    DESTINATION lib/cmake/aLocas
)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    aLocasConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_file(aLocasConfig.cmake.in aLocasConfig.cmake @ONLY)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/aLocasConfig.cmake" "${CMAKE_CURRENT_BINARY_DIR}/aLocasConfigVersion.cmake"
    DESTINATION lib/cmake/aLocas
)
install(
    EXPORT aLocasTargets
    FILE aLocasTargets.cmake
    NAMESPACE aLocas::
    DESTINATION lib/cmake/aLocas
)

enable_testing()
add_subdirectory(test)