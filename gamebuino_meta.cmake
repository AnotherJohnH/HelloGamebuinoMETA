#-------------------------------------------------------------------------------
# Configure compilation and linking

set(CMAKE_SYSTEM_NAME Generic)

include_directories("ArduinoCore-samd/cores/arduino")
include_directories("ArduinoCore-samd/variants/standard")
include_directories("ArduinoCore-samd/libraries/SPI/src")
include_directories("Gamebuino-Classic/")
include_directories("Gamebuino-Classic/utility")


set(CMAKE_BUILD_TYPE Release)

set(CMAKE_C_FLAGS_RELEASE   "-g -Os -w -std=gnu11 \
                             -ffunction-sections -fdata-sections \
                             -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p \
                             -DF_CPU=16000000L -DARDUINO=10813 \
                             -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR")

set(CMAKE_CXX_FLAGS_RELEASE "-g -Os -w -std=gnu++11 \
                             -fpermissive -fno-exceptions -ffunction-sections \
                             -fdata-sections -fno-threadsafe-statics \
                             -Wno-error=narrowing \
                             -MMD -flto -mmcu=atmega328p \
                             -DF_CPU=16000000L -DARDUINO=10813 \
                             -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR")

set(bin_prefix "arm-none-eabi-")

set(CMAKE_ASM_COMPILER      ${bin_prefix}as)
set(CMAKE_C_COMPILER        ${bin_prefix}gcc)
set(CMAKE_CXX_COMPILER      ${bin_prefix}g++)
set(CMAKE_AR                ${bin_prefix}ar)
set(CMAKE_RANLIB            ${bin_prefix}ranlib)
set(CMAKE_OBJCOPY           ${bin_prefix}objcopy)
set(CMAKE_OBJDUMP           ${bin_prefix}objdump)
set(CMAKE_SIZE              ${bin_prefix}size)

set(ld_flags "-w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p")

set(CMAKE_CXX_LINK_EXECUTABLE
    "${bin_prefix}gcc ${ld_flags} <OBJECTS> -o <TARGET>.elf <LINK_LIBRARIES>; \
     ${CMAKE_OBJCOPY} -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 \
                     <TARGET>.elf <TARGET>.eep; \
     ${CMAKE_OBJCOPY} -O ihex -R .eeprom <TARGET>.elf <TARGET>.HEX; \
     ${CMAKE_SIZE} <TARGET>.elf")

# Prevent compiler sanity check when cross-compiling.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#-------------------------------------------------------------------------------

set(src_arduino_core
    ArduinoCore-samd/cores/arduino/main.cpp
    ArduinoCore-samd/cores/arduino/CDC.cpp
    ArduinoCore-samd/cores/arduino/HardwareSerial.cpp
    ArduinoCore-samd/cores/arduino/HardwareSerial0.cpp
    ArduinoCore-samd/cores/arduino/HardwareSerial1.cpp
    ArduinoCore-samd/cores/arduino/HardwareSerial2.cpp
    ArduinoCore-samd/cores/arduino/HardwareSerial3.cpp
    ArduinoCore-samd/cores/arduino/IPAddress.cpp
    ArduinoCore-samd/cores/arduino/PluggableUSB.cpp
    ArduinoCore-samd/cores/arduino/Print.cpp
    ArduinoCore-samd/cores/arduino/Stream.cpp
    ArduinoCore-samd/cores/arduino/Tone.cpp
    ArduinoCore-samd/cores/arduino/USBCore.cpp
    ArduinoCore-samd/cores/arduino/WInterrupts.c
    ArduinoCore-samd/cores/arduino/WMath.cpp
    ArduinoCore-samd/cores/arduino/WString.cpp
    ArduinoCore-samd/cores/arduino/abi.cpp
    ArduinoCore-samd/cores/arduino/hooks.c
    ArduinoCore-samd/cores/arduino/new.cpp
    ArduinoCore-samd/cores/arduino/wiring.c
    ArduinoCore-samd/cores/arduino/wiring_pulse.S
    ArduinoCore-samd/cores/arduino/wiring_analog.c
    ArduinoCore-samd/cores/arduino/wiring_digital.c
    ArduinoCore-samd/cores/arduino/wiring_pulse.c
    ArduinoCore-samd/cores/arduino/wiring_shift.c)

set(src_arduino_libs
    ArduinoCore-samd/libraries/SPI/src/SPI.cpp)

set(src_gamebuino
    Gamebuino-Classic/Gamebuino.cpp
    Gamebuino-Classic/utility/font3x5.c
    Gamebuino-Classic/utility/settings.c
    Gamebuino-Classic/utility/font5x7.c
    Gamebuino-Classic/utility/font3x3.c
    Gamebuino-Classic/utility/Buttons.cpp
    Gamebuino-Classic/utility/Display.cpp
    Gamebuino-Classic/utility/Sound.cpp
    Gamebuino-Classic/utility/Battery.cpp
    Gamebuino-Classic/utility/Backlight.cpp)

set(GB_SRC
    ${src_gamebuino}
    ${src_arduino_libs}
    ${src_arduino_core})

link_libraries(m)
