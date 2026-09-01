platform(apple2 COMPLETE HOSTED PARENT common)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES apple2.h TYPE INCLUDE)
install(FILES apple2.inc DESTINATION ${ASMINCDIR})

add_platform_object_file(apple2-crt0-o crt0.o crt0.S)
target_include_directories(apple2-crt0-o PRIVATE .)
target_link_libraries(apple2-crt0-o PRIVATE common-asminc)

add_platform_library(apple2-crt0
  _Exit.S
)
target_include_directories(apple2-crt0 PRIVATE .)
target_link_libraries(apple2-crt0 PRIVATE common-asminc)
merge_libraries(apple2-crt0
  common-copy-zp-data
  common-init-stack
  common-zero-bss
  common-exit-custom
)

add_platform_library(apple2-c
  getchar.c
  monitor.S
  putchar.c
)
target_include_directories(apple2-c BEFORE PUBLIC .)
target_link_libraries(apple2-c PRIVATE common-asminc)
