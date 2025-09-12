cmake_minimum_required(VERSION 3.20)
project(lyricedit)

set(CMAKE_CXX_STANDARD 20)

function(add_raylib)
    find_package(raylib 5.5)
    if(NOT raylib_FOUND)
        # Didn't find raylib - download it
        FetchContent_Declare(raylib
            GIT_REPOSITORY https://github.com/raysan5/raylib
            GIT_TAG 5.5
            GIT_SHALLOW ON
            GIT_PROGRESS ON
            EXCLUDE_FROM_ALL
        )
        FetchContent_MakeAvailable(raylib)
        include_directories("${raylib_SOURCE_DIR}/src")
    endif()
endfunction()

function(add_externals)
    # rlImGui
    include_directories("external/rlImGui")
    add_library(rlImGui STATIC "external/rlImGui/rlImGui.cpp")

    # imgui
    include_directories("external/imgui")
    file(GLOB IMGUI_SOURCES CONFIGURE_DEPENDS "external/imgui/*.cpp")
    add_library(imgui STATIC ${IMGUI_SOURCES})

    # libtinyfiledialogs
    include_directories("external/libtinyfiledialogs/")
    add_library(tinyfiledialogs STATIC "external/libtinyfiledialogs/tinyfiledialogs.c")

    # tinyfd_cpp
    include_directories("tinyfd_cpp")
    add_library(tinyfd_cpp STATIC "tinyfd_cpp/tinyfd_cpp.cc")
    target_link_libraries(tinyfd_cpp tinyfiledialogs)
endfunction()

function(copy_assets_target)
    set(assets_SOURCE_DIR "${CMAKE_SOURCE_DIR}/assets")
    set(assets_DESTINATION_DIR "${CMAKE_BINARY_DIR}/assets")

    file(COPY ${assets_SOURCE_DIR} DESTINATION ${assets_DESTINATION_DIR})

    add_custom_target(copy_assets ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/assets" "${CMAKE_BINARY_DIR}/assets"
        COMMENT "Copying assets from ${assets_SOURCE_DIR} to ${assets_DESTINATION_DIR}"
    )
endfunction()

add_raylib()
add_externals()
copy_assets_target()

if(LINUX)
    add_compile_options("-fsanitize=address")
    add_link_options("-fsanitize=address")
endif()

file(GLOB_RECURSE SOURCE CONFIGURE_DEPENDS "src/*.c*")
add_executable(lyricedit ${SOURCE})
target_link_libraries(lyricedit raylib rlImGui imgui tinyfiledialogs tinyfd_cpp)
add_dependencies(lyricedit copy_assets)
