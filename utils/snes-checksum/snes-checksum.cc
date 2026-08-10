#include <cstdint>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

static int fail(const std::string &message) {
  std::cerr << "snes-checksum: " << message << '\n';
  return 1;
}

#if defined(SNES_CHECKSUM_MAPPING_LOROM)
static constexpr size_t HeaderOffset = 0x7fc0;
static constexpr uint8_t MapMode = 0x20;
static constexpr const char *MappingName = "LoROM";
#elif defined(SNES_CHECKSUM_MAPPING_HIROM)
static constexpr size_t HeaderOffset = 0xffc0;
static constexpr uint8_t MapMode = 0x21;
static constexpr const char *MappingName = "HiROM";
#else
#error "SNES checksum mapping must be selected at build time"
#endif

int main(int argc, char **argv) {
  if (argc != 2) {
    return fail("usage: snes-checksum <rom.elf>");
  }

  std::string romPath = argv[1];
  const std::string elfSuffix = ".elf";
  if (romPath.size() <= elfSuffix.size() ||
      romPath.compare(romPath.size() - elfSuffix.size(), elfSuffix.size(),
                      elfSuffix) != 0) {
    return fail("expected an ELF filename ending in .elf");
  }
  romPath.resize(romPath.size() - elfSuffix.size());

  std::ifstream input(romPath, std::ios::binary);
  if (!input) {
    return fail("cannot open ROM: " + romPath);
  }
  std::vector<uint8_t> rom((std::istreambuf_iterator<char>(input)),
                           std::istreambuf_iterator<char>());

  if (rom.size() < 0x8000 || (rom.size() & (rom.size() - 1)) != 0) {
    return fail("ROM size must be a power of two and at least 32 KiB");
  }

  constexpr size_t MapModeOffset = HeaderOffset + 0x15;
  constexpr size_t RomSizeOffset = HeaderOffset + 0x17;
  constexpr size_t ChecksumOffset = HeaderOffset + 0x1c;
  if (rom.size() < HeaderOffset + 0x20) {
    return fail(std::string(MappingName) + " header does not fit in ROM");
  }
  if (rom[MapModeOffset] != MapMode) {
    return fail(std::string(MappingName) + " map-mode byte does not match target");
  }

  size_t sizeKiB = rom.size() / 1024;
  uint8_t encodedSize = 0;
  while ((size_t{1} << encodedSize) < sizeKiB) {
    ++encodedSize;
  }
  if ((size_t{1} << encodedSize) != sizeKiB ||
      rom[RomSizeOffset] != encodedSize) {
    return fail("ROM-size header byte does not match file size");
  }

  rom[ChecksumOffset] = 0xff;
  rom[ChecksumOffset + 1] = 0xff;
  rom[ChecksumOffset + 2] = 0x00;
  rom[ChecksumOffset + 3] = 0x00;

  uint16_t checksum = 0;
  for (uint8_t byte : rom) {
    checksum = static_cast<uint16_t>(checksum + byte);
  }
  const uint16_t complement = checksum ^ 0xffff;

  rom[ChecksumOffset] = complement & 0xff;
  rom[ChecksumOffset + 1] = complement >> 8;
  rom[ChecksumOffset + 2] = checksum & 0xff;
  rom[ChecksumOffset + 3] = checksum >> 8;

  std::ofstream output(romPath, std::ios::binary | std::ios::trunc);
  if (!output) {
    return fail("cannot update ROM: " + romPath);
  }
  output.write(reinterpret_cast<const char *>(rom.data()), rom.size());
  if (!output) {
    return fail("failed while updating ROM: " + romPath);
  }
  return 0;
}
