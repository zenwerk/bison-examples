set(CMAKE_CXX_STANDARD 20)

find_program(BISON NAMES bison bison.exe)
if(NOT BISON)
    message(WARNING "bison (or bison.exe) program is required for ckl")
endif()

find_program(RE2C NAMES re2c re2c.exe)
if(NOT RE2C)
    message(WARNING "re2c (or re2c.exe) program is required for ckl")
endif()

add_library(parser OBJECT)
target_sources(parser PRIVATE
    ast.cc
    y.tab.cc
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/y.tab.cc
    COMMAND ${BISON} -y -v -o ${CMAKE_CURRENT_SOURCE_DIR}/y.tab.cc --defines=${CMAKE_CURRENT_SOURCE_DIR}/y.tab.h ${CMAKE_CURRENT_SOURCE_DIR}/parse.y -Wno-yacc
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/parse.y
    COMMENT "Generating y.tab.cc"
    # WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/lexer.cc
    COMMAND ${RE2C} -i -o ${CMAKE_CURRENT_SOURCE_DIR}/lexer.cc ${CMAKE_CURRENT_SOURCE_DIR}/lexer.re.cc
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/lexer.re.cc
    COMMENT "Generating lexer.cc"
    # WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_target(lexer.cc ALL
    SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/lexer.cc
)

add_dependencies(parser lexer.cc)


add_executable(ckl
    main.cc
    exec.cc
)

target_link_libraries(ckl parser)