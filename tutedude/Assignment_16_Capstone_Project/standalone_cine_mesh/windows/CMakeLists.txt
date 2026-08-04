# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)

# The name of the executable created for the application.
# (If your app executable has a unique name, change "runner" to match it)
set(BINARY_NAME "runner")

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release" CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Profile" "Release")
  endif()
endif()

# Define standard compiler flags.
if(NOT IS_MULTICONFIG)
  set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")
  set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
endif()

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Compilation settings that should be applied to most targets.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PRIVATE cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100" /wd"4324" /wd"4505")
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "WIN32_LEAN_AND_MEAN")
  target_compile_definitions(${TARGET} PRIVATE "NOMINMAX")

  if(MSVC)
    target_compile_options(${TARGET} PRIVATE /Zc:__cplusplus)
  endif()
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build rules.
add_subdirectory("runner")

# Generated plugin build rules, updates automatically.
include(flutter/generated_plugins.cmake)


# ==============================================================================
# 🔥 CUSTOM BYPASS FOR FIREBASE & HEAVY DEPENDENCIES REDOWNLOADS 🔥
# ==============================================================================
if(WIN32)
  # Define our local source folder at the app root level
  set(LOCAL_DEP_DIR "${CMAKE_SOURCE_DIR}/../native_dependencies")
  set(TARGET_EXTRACT_BASE_DIR "${CMAKE_BINARY_DIR}/extracted")

  # --------------------------------------------------------------------------
  # 1. Bypass Firebase C++ SDK (1.73 GB File)
  # --------------------------------------------------------------------------
  set(FIREBASE_TARGET_DIR "${TARGET_EXTRACT_BASE_DIR}/firebase_cpp_sdk_windows")

  if(NOT EXISTS "${FIREBASE_TARGET_DIR}")
    message(STATUS "🧹 Flutter Clean detected! Injecting local Firebase SDK archive...")

    file(MAKE_DIRECTORY "${FIREBASE_TARGET_DIR}")
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf "${LOCAL_DEP_DIR}/firebase_cpp_sdk_windows.zip"
            WORKING_DIRECTORY "${FIREBASE_TARGET_DIR}"
            RESULT_VARIABLE FIREBASE_RESULT
    )

    if(NOT FIREBASE_RESULT EQUAL 0)
      message(FATAL_ERROR "❌ Extraction failed for local firebase_cpp_sdk_windows.zip")
    else()
      message(STATUS "✅ Successfully injected and unzipped Local Firebase SDK!")
    endif()
  endif()

endif()
# ==============================================================================
