foreach(mapping IN ITEMS lorom hirom)
  set(target snes-${mapping}-checksum)
  string(TOUPPER ${mapping} mapping_upper)
  add_executable(${target} snes-checksum.cc)
  set_property(TARGET ${target} PROPERTY CXX_STANDARD 11)
  target_compile_definitions(${target} PRIVATE
    SNES_CHECKSUM_MAPPING_${mapping_upper}=1)
  install(TARGETS ${target})
endforeach()

# The platform ExternalProject builds examples against its private staged SDK
# before the top-level install step. Stage the post-link tool there as well.
if(NOT CMAKE_CROSSCOMPILING)
  set(stage_bin ${CMAKE_BINARY_DIR}/mos-platform/build/install/bin)
  foreach(mapping IN ITEMS lorom hirom)
    set(target snes-${mapping}-checksum)
    add_custom_command(TARGET ${target} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E make_directory ${stage_bin}
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
              $<TARGET_FILE:${target}> ${stage_bin}/${target})
  endforeach()
endif()
