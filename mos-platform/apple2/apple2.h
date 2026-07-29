#ifndef _APPLE2_H
#define _APPLE2_H

#include <stdint.h>

#define APPLE2_PRODOS_MLI ((uintptr_t)0xbf00)
#define APPLE2_PRODOS_VERSION (*(volatile uint8_t *)0xbffd)
#define APPLE2_MACHINE_ID (*(volatile uint8_t *)0xbf98)

#endif
