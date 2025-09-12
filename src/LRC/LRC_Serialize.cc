#include "../Util.hh"
#include "LRC.hh"

using namespace lc;

std::string LRC::serialize() {
  std::string res;
  if (!songTitle.empty()) {
    res += LC_FORMAT("[ti:{}]\n", songTitle);
  }
  if (!artist.empty()) {
    res += LC_FORMAT("[ar:{}]\n", artist);
  }
  if (!album.empty()) {
    res += LC_FORMAT("[al:{}]\n", album);
  }
  if (!author.empty()) {
    res += LC_FORMAT("[au:{}]\n", author);
  }
  if (!lyricist.empty()) {
    res += LC_FORMAT("[lr:{}]\n", lyricist);
  }
  if (!lrcAuthor.empty()) {
    res += LC_FORMAT("[by:{}]\n", lrcAuthor);
  }
  res += LC_FORMAT("[re:rvnfml's lyricedit nightly]\n");

  for (const LyricLine& line : lyrics) {
    std::string timestamp = Util::formatTimeFloatSeconds(line.time);
    std::string text = line.text;
    res += LC_FORMAT("[{}]{}\n", timestamp, text);
  }

  return res;
}