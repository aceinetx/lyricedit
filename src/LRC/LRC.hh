#pragma once
#include "../LyricLine.hh"
#include <string>
#include <vector>

namespace lc {
class LRC {
public:
  std::string songTitle;
  std::string artist;
  std::string album;
  std::string author;
  std::string lyricist;
  std::string lrcAuthor;
  std::vector<LyricLine> lyrics;

public:
  LRC();

  std::string serialize();
  void deserialize(std::string text);
};
} // namespace lc