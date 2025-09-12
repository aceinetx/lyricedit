#include "LRCDeserializer.hh"
#include "../Util.hh"

using namespace lc;

std::vector<LyricLine> LRCDeserailizer::deserialize(std::string lrc) {
  std::vector<LyricLine> lyrics;
  std::vector<std::string> lines = Util::split(lrc, "\n");

  for (const auto& line : lines) {
    if (line.empty())
      continue;

    // parse time
    float time = 0.0f;
    if (line.starts_with("[")) {
      int minutes, seconds, milliseconds;
      minutes = (line[1] - '0') * 10 + (line[2] - '0');
      seconds = (line[4] - '0') * 10 + (line[5] - '0');
      milliseconds = (line[7] - '0') * 10 + (line[8] - '0');

      time = (minutes * 60) + seconds + (milliseconds * 0.01);
    }
    std::string text = line;
    text.erase(text.begin(), text.begin() + text.find(']') + 1);
    lyrics.push_back({time, text});
  }

  return lyrics;
}