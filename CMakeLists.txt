cmake_minimum_required(VERSION 3.21)

project(iOS120Hz VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(${PROJECT_NAME} SHARED
    src/main.mm
)

if(IOS)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        "-framework QuartzCore"
        "-framework UIKit"
        "-framework Foundation"
    )
endif()

setup_geode_mod(${PROJECT_NAME})
