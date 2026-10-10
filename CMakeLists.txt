cmake_minimum_required(VERSION 3.21)

project(bubu VERSION 1.0)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Force static libs" FORCE)

set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

find_package(Git QUIET)
if (GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
  execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE GIT_SUBMOD_RESULT)
  if (NOT GIT_SUBMOD_RESULT EQUAL "0")
    message(FATAL_ERROR "update git submodule failed: ${GIT_SUBMOD_RESULT}")
  endif ()
endif ()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-Wno-psabi -Wno-ignored-qualifiers)
endif ()

if (APPLE)
  set(SYS_LIBS "-framework Security -framework Foundation -framework SystemConfiguration")
elseif (ANDROID)
  set(SYS_LIBS log android)
elseif (UNIX)
  set(SYS_LIBS pthread dl)
endif ()

include(dep/dep.cmake)
add_subdirectory(src)
add_subdirectory(app)
