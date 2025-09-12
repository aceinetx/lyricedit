#include "LyricEdit.hh"
#include <iostream>
#include <tinyfd_cpp.hh>

using namespace lc;

void LyricEdit::openMusicDialog() {
  music.path = tinyfd::openFileDialog("Open music", "./", {"*.mp3"}, "Music file");
  loadMusic(music.path);
}

void LyricEdit::saveLRCDialog() {
}