#pragma once
#include <string>

namespace lc {
class LyricLine {
private:
  size_t uid;

public:
  float time;
  std::string text;

public:
  LyricLine();
  LyricLine(float time, std::string text);

  size_t getUID();
};
} // namespace lc