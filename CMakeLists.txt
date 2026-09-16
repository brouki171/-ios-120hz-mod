cmake_minimum_required(VERSION 3.21)

project(iOS120Hz VERSION 1.0.0)

add_library(${PROJECT_NAME} SHARED
    src/main.mm
)

setup_geode_mod(${PROJECT_NAME})
