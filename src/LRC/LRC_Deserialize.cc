#include "../Util.hh"
#include "LRC.hh"
#include <regex>

using namespace lc;

std::regex g_lyricRegex("\\[[0-9][0-9]:[0-9][0-9]\\.[0-9][0-9]\\]?.*");
std::regex g_metadataRegex(R"exp(\[([a-zA-Z]+):([^\]]+)\])exp");

void LRC::deserialize(std::string text) {
  std::vector<std::string> lines = Util::split(text, "\n");

  lyrics.clear();

  for (const auto& line : lines) {
    if (line.empty())
      continue;

    // parse metadata
    std::smatch metadata_match;
    if (std::regex_search(line, metadata_match, g_metadataRegex)) {
      std::string key = metadata_match[1];
      std::string val = metadata_match[2];
      if (key == "ti")
        songTitle = val;
      if (key == "ar")
        artist = val;
      if (key == "al")
        album = val;
      if (key == "au")
        author = val;
      if (key == "lr")
        lyricist = val;
      if (key == "by")
        lrcAuthor = val;
      continue;
    }

    // parse time
    if (std::regex_match(line, g_lyricRegex)) {
      float time = 0.0f;

      int minutes, seconds, milliseconds;
      minutes = (line[1] - '0') * 10 + (line[2] - '0');
      seconds = (line[4] - '0') * 10 + (line[5] - '0');
      milliseconds = (line[7] - '0') * 10 + (line[8] - '0');

      time = (minutes * 60) + seconds + (milliseconds * 0.01);

      std::string text = line;
      text.erase(text.begin(), text.begin() + text.find(']') + 1);
      lyrics.push_back({time, text});
      continue;
    }
  }
}