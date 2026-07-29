# Apple II

This platform produces ProDOS 8 system-program (`SYS`, file type `$ff`)
binaries. ProDOS loads them at `$2000`; copy the linked output to a ProDOS
volume with a filename ending in `.SYSTEM` and set its file type to `SYS`.

The initial implementation targets a 64 KiB Apple II running ProDOS and uses
the Monitor ROM for 40-column text input and output. It is also suitable for an
Apple IIe in 40-column mode. It does not use hi-res graphics or auxiliary
memory.

Compile with `mos-apple2-clang` or `mos-apple2-clang++`.
