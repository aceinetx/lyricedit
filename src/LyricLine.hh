#pragma once
#include <string>

namespace lc {
class LyricLine {
private:
  std::hash<std::string> hasher;
  std::string hash;

public:
  float time;
  std::string text;

public:
  LyricLine();
  LyricLine(float time, std::string text);

  void updateHash();
  std::string getHash();
};
} // namespace lc