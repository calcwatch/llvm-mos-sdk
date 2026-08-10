platform(snes-lorom COMPLETE PARENT snes)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES snes-lorom.h TYPE INCLUDE)
install(FILES banked-rom.ld banked-output.ld TYPE LIB)

add_platform_library(snes-lorom-c snes-lorom.S)
target_compile_options(snes-lorom-c PUBLIC -mcpu=mosw65816)
target_link_libraries(snes-lorom-c PRIVATE common-asminc)
