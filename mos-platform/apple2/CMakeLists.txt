platform(apple2 COMPLETE HOSTED PARENT common)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES apple2.h TYPE INCLUDE)
install(FILES apple2.inc DESTINATION ${ASMINCDIR})

add_platform_library(apple2-crt0
  _Exit.S
)
merge_libraries(apple2-crt0
  common-copy-zp-data
  common-init-stack
  common-zero-bss
  common-exit-custom
)

add_platform_library(apple2-c
  getchar.c
  putchar.c
)
target_include_directories(apple2-c SYSTEM BEFORE PUBLIC .)
