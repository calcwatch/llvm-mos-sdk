platform(snes-hirom COMPLETE PARENT snes)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES snes-hirom.h TYPE INCLUDE)
install(FILES banked-rom.ld banked-output.ld TYPE LIB)

add_platform_library(snes-hirom-c snes-hirom.S)
target_compile_options(snes-hirom-c PUBLIC -mcpu=mosw65816)
target_link_libraries(snes-hirom-c PRIVATE common-asminc)
