#pragma once

namespace lc {
class LyricEdit {
private:
  LyricEdit();

  void draw();
  void drawImGui();

public:
  LyricEdit(const LyricEdit&) = delete;
  auto operator=(const LyricEdit&) = delete;

  static LyricEdit& getInstance();

  void openMusicDialog();

  void run();
};
} // namespace lc