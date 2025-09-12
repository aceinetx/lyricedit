#include "LyricLine.hh"

using namespace lc;

size_t get_uid() {
  static size_t g_uid = 0;
  return ++g_uid;
}

LyricLine::LyricLine() {
  uid = get_uid();
}

LyricLine::LyricLine(float time, std::string text) : text(text), time(time) {
  uid = get_uid();
}

size_t LyricLine::getUID() {
  return uid;
}