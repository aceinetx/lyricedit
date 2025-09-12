#pragma once
#include "MusicResource.hh"

namespace lc {
class LyricEdit {
private:
  MusicResource music;

private:
  LyricEdit();
  ~LyricEdit();

  void draw();
  void drawImGui();

public:
  LyricEdit(const LyricEdit&) = delete;
  auto operator=(const LyricEdit&) = delete;

  static LyricEdit& getInstance();

  void openMusicDialog();
  void loadMusic(std::string path);
  void playMusic();
  void stopMusic();
  void resumeMusic();
  void pauseMusic();

  void run(std::string autoloadMusicPath = "");
};
} // namespace lc