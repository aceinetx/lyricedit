#include "lyricedit.hh"
#include <tinyfd_cpp.hh>

using namespace lc;

void LyricEdit::openMusicDialog() {
  tinyfd::openFileDialog("Open music", "", {"*.mp3"});
}