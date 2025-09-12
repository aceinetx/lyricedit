#include "LyricLine.hh"

using namespace lc;

LyricLine::LyricLine() {
  updateHash();
}

LyricLine::LyricLine(float time, std::string text) : text(text), time(time) {
  updateHash();
}

void LyricLine::updateHash() {
  hash = hasher(text);
}

std::string LyricLine::getHash() {
  return hash;
}