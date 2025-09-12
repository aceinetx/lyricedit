#include "LRCSerializer.hh"
#include "../Util.hh"

using namespace lc;

std::string LRCSerailizer::serialize(std::vector<LyricLine> lines) {
  std::string res;
  for (const LyricLine& line : lines) {
    std::string timestamp = Util::formatTimeFloatSeconds(line.time);
    std::string text = line.text;
    res += std::format("[{}]{}", timestamp, text);
    res += "\n";
  }

  return res;
}