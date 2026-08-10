cmake_minimum_required(VERSION 3.18)

project(test-snes-lorom LANGUAGES C)

include(CTest)

add_executable(banked.sfc banked.c)
target_link_options(banked.sfc PRIVATE -Wl,--defsym=__rom_size=128)

# Validates compilation, linking, section placement, and API compatibility.
# It inspects the ROM but does not execute read8 in an emulator.
add_test(NAME snes-lorom-banked-layout COMMAND ${CMAKE_COMMAND}
  -DROM=$<TARGET_FILE:banked.sfc> -P ${CMAKE_CURRENT_SOURCE_DIR}/verify.cmake)

add_executable(boundary.sfc boundary.c)
target_link_options(boundary.sfc PRIVATE -Wl,--defsym=__rom_size=4096)
add_test(NAME snes-lorom-boundary-layout COMMAND ${CMAKE_COMMAND}
  -DROM=$<TARGET_FILE:boundary.sfc>
  -P ${CMAKE_CURRENT_SOURCE_DIR}/verify-boundary.cmake)

add_executable(minimal.sfc minimal.c)
add_test(NAME snes-lorom-minimum-size COMMAND ${CMAKE_COMMAND}
  -DROM=$<TARGET_FILE:minimal.sfc> -DEXPECTED_SIZE=32768
  -P ${CMAKE_CURRENT_SOURCE_DIR}/../verify-size.cmake)

add_executable(near-capacity.sfc near-capacity.c)
add_test(NAME snes-lorom-near-capacity-first-bank COMMAND ${CMAKE_COMMAND}
  -DROM=$<TARGET_FILE:near-capacity.sfc> -DEXPECTED_SIZE=32768
  -P ${CMAKE_CURRENT_SOURCE_DIR}/../verify-size.cmake)

foreach(name size-too-small size-too-large size-non-power-of-two)
  add_executable(${name} EXCLUDE_FROM_ALL minimal.c)
endforeach()
target_link_options(size-too-small PRIVATE -Wl,--defsym=__rom_size=16)
target_link_options(size-too-large PRIVATE -Wl,--defsym=__rom_size=8192)
target_link_options(size-non-power-of-two PRIVATE -Wl,--defsym=__rom_size=96)
add_executable(bank-out-of-range EXCLUDE_FROM_ALL invalid-bank.c)
add_executable(malformed-bank EXCLUDE_FROM_ALL malformed-bank.c)
add_executable(first-bank-overflow EXCLUDE_FROM_ALL first-bank-overflow.c)
foreach(name size-too-small size-too-large size-non-power-of-two
             bank-out-of-range malformed-bank first-bank-overflow)
  add_test(NAME snes-lorom-invalid-${name}
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${name})
  set_tests_properties(snes-lorom-invalid-${name} PROPERTIES WILL_FAIL TRUE)
endforeach()
