#include "LRC/LRCDeserializer.hh"
#include "LRC/LRCSerializer.hh"
#include "LyricEdit.hh"
#include <fstream>
#include <sstream>
#include <tinyfd_cpp.hh>

using namespace lc;

void LyricEdit::openMusicDialog() {
  music.path = tinyfd::openFileDialog("Open music", "./", {"*.mp3"}, "Music file");
  loadMusic(music.path);
}

void LyricEdit::saveLRCDialog() {
  std::string path = tinyfd::saveFileDialog("Save lyrics", "./", {"*.lrc"}, "Lyrics file");
  path.append(".lrc");

  std::ofstream file(path);
  file << LRCSerailizer::serialize(lyrics);
  file.close();
}

void LyricEdit::openLRCDialog() {
  std::string path = tinyfd::openFileDialog("Save lyrics", "./", {"*.lrc"}, "Lyrics file");
  std::string text;

  std::ifstream file(path);
  std::stringstream buffer;
  buffer << file.rdbuf();
  file.close();

  lyrics = LRCDeserailizer::deserialize(text);
}