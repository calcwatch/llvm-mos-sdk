platform(snes PARENT common)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES snes.h TYPE INCLUDE)

add_platform_object_file(snes-crt0-o crt0.o crt0.S)
target_compile_options(snes-crt0-o PUBLIC -mcpu=mosw65816)

add_platform_library(snes-crt0)
target_compile_options(snes-crt0 PUBLIC -mcpu=mosw65816)
merge_libraries(snes-crt0
  common-copy-data
  common-init-stack
  common-zero-bss
  common-exit-loop
)
