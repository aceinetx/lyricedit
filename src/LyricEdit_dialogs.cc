#include "LRC/LRCDeserializer.hh"
#include "LRC/LRCSerializer.hh"
#include "LyricEdit.hh"
#include <filesystem>
#include <fstream>
#include <sstream>
#include <tinyfd_cpp.hh>

using namespace lc;

void LyricEdit::openMusicDialog() {
  music.path = tinyfd::openFileDialog("Open music", "./", {"*.mp3"}, "Music file");
  if (!std::filesystem::exists(music.path)) {
    music.path.clear();
    return;
  }
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
  if (!std::filesystem::exists(path))
    return;
  std::string text;

  std::ifstream file(path);
  std::stringstream buffer;
  buffer << file.rdbuf();
  text = buffer.str();
  file.close();

  lyrics = LRCDeserializer::deserialize(text);
}