#pragma once
#include "LyricLine.hh"
#include "MusicResource.hh"
#include <vector>

namespace lc {
class LyricEdit {
private:
  MusicResource music;
  std::vector<LyricLine> lyrics;

private:
  LyricEdit();
  ~LyricEdit();

  void draw();
  void drawImGui();
  void drawFileWindowContent();
  void drawSongControlsWindowContent();
  void drawLyricsWindowContent();

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