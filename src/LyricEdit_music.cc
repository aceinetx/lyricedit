#include "LyricEdit.hh"
#include "raylib.h"
#include <iostream>

using namespace lc;

void LyricEdit::loadMusic(std::string path) {
  if (!music.path.empty())
    UnloadMusicStream(music.raylibResource);

  music.path = path;
  music.raylibResource = LoadMusicStream(music.path.c_str());
  if (music.raylibResource.frameCount <= 0)
    music.path.clear();
}

void LyricEdit::playMusic() {
  if (music.path.empty())
    return;
  PlayMusicStream(music.raylibResource);
}

void LyricEdit::stopMusic() {
  if (music.path.empty())
    return;
  StopMusicStream(music.raylibResource);
}

void LyricEdit::resumeMusic() {
  if (music.path.empty())
    return;
  ResumeMusicStream(music.raylibResource);
}

void LyricEdit::pauseMusic() {
  if (music.path.empty())
    return;
  PauseMusicStream(music.raylibResource);
}