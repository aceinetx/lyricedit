#pragma once
#include "LRC/LRC.hh"
#include "MusicResource.hh"
#include <vector>

namespace lc {
class LyricEdit {
private:
  MusicResource music;
  LRC lrc;

private:
  LyricEdit();
  ~LyricEdit();

  void draw();
  void drawImGui();
  void drawFileWindowContent();
  void drawSongControlsWindowContent();
  void drawLyricsWindowContent();
  void drawEditWindowContent();

public:
  LyricEdit(const LyricEdit&) = delete;
  auto operator=(const LyricEdit&) = delete;

  static LyricEdit& getInstance();

  void openMusicDialog();
  void saveLRCDialog();
  void openLRCDialog();

  void loadMusic(std::string path);
  void playMusic();
  void stopMusic();
  void resumeMusic();
  void pauseMusic();

  void sortLyricsArray();

  void run(std::string autoloadMusicPath = "");
};
} // namespace lc