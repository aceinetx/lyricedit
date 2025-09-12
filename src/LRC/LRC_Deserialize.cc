#include "../Util.hh"
#include "LRC.hh"
#include <regex>

using namespace lc;

std::regex g_lyricLineRegex("\\[[0-9][0-9]:[0-9][0-9]\\.[0-9][0-9]\\]?.*");
std::regex g_songTitleRegex("\\[ti\\:.*\\]$");
std::regex g_artistRegex("\\[ti\\:.*\\]$");
std::regex g_albumRegex("\\[al\\:.*\\]$");

void LRC::deserialize(std::string text) {
  std::vector<std::string> lines = Util::split(text, "\n");

  lyrics.clear();

  for (const auto& line : lines) {
    if (line.empty())
      continue;

    if (std::regex_match(line, g_lyricLineRegex)) {
      // parse time
      float time = 0.0f;

      int minutes, seconds, milliseconds;
      minutes = (line[1] - '0') * 10 + (line[2] - '0');
      seconds = (line[4] - '0') * 10 + (line[5] - '0');
      milliseconds = (line[7] - '0') * 10 + (line[8] - '0');

      time = (minutes * 60) + seconds + (milliseconds * 0.01);

      std::string text = line;
      text.erase(text.begin(), text.begin() + text.find(']') + 1);
      lyrics.push_back({time, text});
    } else if (std::regex_match(line, g_songTitleRegex)) {
      std::string text = line;
      text.erase(text.begin(), text.begin() + text.find(':') + 1);
      text.pop_back();
      songTitle = text;
    } else if (std::regex_match(line, g_artistRegex)) {
      std::string text = line;
      text.erase(text.begin(), text.begin() + text.find(':') + 1);
      text.pop_back();
      artist = text;
    }
  }
}