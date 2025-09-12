#pragma once
#include <raylib.h>
#include <string>

namespace lc {
struct MusicResource {
  Music raylibResource;
  std::string path;

  int getPlayedTimeMilliseconds();
  int getPlayedTimeSeconds();
  int getPlayedTimeMinutes();

  std::string getPlayedTimeFormatted();
};
} // namespace lc