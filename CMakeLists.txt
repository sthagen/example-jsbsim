cmake_minimum_required(VERSION 3.7...3.23)
if(${CMAKE_VERSION} VERSION_LESS 3.12)
    cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
endif()

# ---- Project ---- WIP ----

project(example-jsbsim LANGUAGES CXX)

# ---- Enable FetchContent ----

include(FetchContent)

# ---- Add dependencies via FetchContent ----

# ---- Fetch CPM ----
set(CPM_DOWNLOAD_VERSION 0.35.0)

if(CPM_SOURCE_CACHE)
    set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
    set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
    set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()

if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
    message(STATUS "Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
    file(DOWNLOAD
            https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
            ${CPM_DOWNLOAD_LOCATION}
            )
endif()

include(${CPM_DOWNLOAD_LOCATION})

# ---- Add dependencies via CPM ----
# See https://github.com/cpm-cmake/CPM.cmake for details and examples

CPMAddPackage(
        NAME jsbsim
        GITHUB_REPOSITORY JSBSim-Team/jsbsim
        GIT_TAG v1.1.11
        OPTIONS
        "BUILD_DOCS FALSE"
        "BUILD_PYTHON_MODULE FALSE"
        "BUILD_SHARED_LIBS TRUE"
        "JSBSIM_ENABLE_PLUGINS TRUE"
)

if(jsbsim_ADDED)
    add_library(jsbsim INTERFACE)
    target_include_directories(jsbsim INTERFACE ${jsbsim_SOURCE_DIR}/src/)
    message("-- [example-jsbsim] added ${jsbsim_SOURCE_DIR}/src/ as include")
endif()

CPMAddPackage(
        NAME doctest
        GITHUB_REPOSITORY sthagen/doctest-doctest
        GIT_TAG 2020.12
)

CPMAddPackage(
        NAME cxxopts
        GITHUB_REPOSITORY jarro2783/cxxopts
        VERSION 3.0.0
        OPTIONS
        "CXXOPTS_BUILD_EXAMPLES Off"
        "CXXOPTS_BUILD_TESTS Off"
)

CPMAddPackage(
        NAME nlohmann_json
        VERSION 3.10.5
        # not using the repo as it takes forever to clone
        URL https://github.com/nlohmann/json/releases/download/v3.10.5/include.zip
        URL_HASH SHA256=b94997df68856753b72f0d7a3703b7d484d4745c567f3584ef97c96c25a5798e
)

if (nlohmann_json_ADDED)
    add_library(nlohmann_json INTERFACE)
    target_include_directories(nlohmann_json INTERFACE ${nlohmann_json_SOURCE_DIR})
endif ()

CPMAddPackage(
        NAME spdlog
        GITHUB_REPOSITORY sthagen/spdlog
        GIT_TAG 2022.3.24
)

CPMAddPackage(
        NAME tomlplusplus
        GIT_REPOSITORY https://github.com/sthagen/tomlplusplus.git
        VERSION 3.0.1
        # 3.0.1 is released by Mark Gillard (upstream), but we read from a fork so use the associated commit directly
        GIT_TAG 8e669aa6990e0ed219c169d491472d749f54c393
)

if(tomlplusplus_ADDED)
    add_library(tomlplusplus INTERFACE)
    target_include_directories(tomlplusplus INTERFACE ${tomlplusplus_SOURCE_DIR}/include/)
    message("-- [example-imath] added ${tomlplusplus_SOURCE_DIR}/include/ as include")
endif()

# ---- Create tool binary ----
add_executable(example
        example/main.cpp
)
set_target_properties(example PROPERTIES CXX_STANDARD 17)

target_link_libraries(example jsbsim)  # cxxopts nlohmann_json spdlog tomlplusplus

# ---- Enable testing ----

enable_testing()
