file(SIZE "${ROM}" actual_size)
if(NOT actual_size EQUAL EXPECTED_SIZE)
  message(FATAL_ERROR "Expected ${EXPECTED_SIZE} bytes, got ${actual_size}")
endif()
