#pragma once
#include <raylib.h>
#include <string>

namespace lc {
struct MusicResource {
  Music raylibResource;
  std::string path;

  std::string getTimeFormatted();
};
} // namespace lc