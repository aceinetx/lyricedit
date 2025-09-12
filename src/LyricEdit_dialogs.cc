#include "LyricEdit.hh"
#include <filesystem>
#include <fstream>
#include <sstream>
#include <tinyfd_cpp.hh>

using namespace lc;

void LyricEdit::openMusicDialog() {
  std::filesystem::path path = tinyfd::openFileDialog("Open music", "./", {"*.mp3"}, "Music file");
  if (!std::filesystem::exists(path))
    return;

  loadMusic(path);
  music.path = path;
}

void LyricEdit::saveLRCDialog() {
  std::filesystem::path path =
      tinyfd::saveFileDialog("Save lyrics", "./", {"*.lrc"}, "Lyrics file");
  if (!path.has_extension()) {
    path.replace_extension("lrc");
  }

  std::ofstream file(path);
  file << lrc.serialize();
  file.close();
}

void LyricEdit::openLRCDialog() {
  std::filesystem::path path =
      tinyfd::openFileDialog("Save lyrics", "./", {"*.lrc"}, "Lyrics file");
  if (!std::filesystem::exists(path))
    return;

  std::string text;

  std::ifstream file(path);
  std::stringstream buffer;
  buffer << file.rdbuf();
  text = buffer.str();
  file.close();

  lrc.deserialize(text);
}