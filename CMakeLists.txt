cmake_minimum_required(VERSION 3.20)
project(lyricedit)

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
    include_directories("external/imgui")
    include_directories("external/rlImGui")

    add_library(rlImGui STATIC "external/rlImGui/rlImGui.cpp")

    file(GLOB IMGUI_SOURCES CONFIGURE_DEPENDS "external/imgui/*.cpp")
    add_library(imgui STATIC ${IMGUI_SOURCES})
endfunction()

add_raylib()
add_externals()

file(GLOB_RECURSE SOURCE CONFIGURE_DEPENDS "src/*.c*")
add_executable(lyricedit ${SOURCE})
target_link_libraries(lyricedit raylib rlImGui imgui)
