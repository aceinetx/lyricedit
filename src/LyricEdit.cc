#include "LyricEdit.hh"

#include "LyricLine.hh"
#include <algorithm>
#include <imgui.h>
#include <raylib.h>
#include <rlImGui.h>

using namespace lc;

LyricEdit::LyricEdit() : lyrics({{0.0f, "Line 1"}, {1.5f, "Line 2"}, {3.0f, "Line 3"}}) {
}
LyricEdit::~LyricEdit() {
  if (!music.path.empty()) {
    UnloadMusicStream(music.raylibResource);
  }
}

LyricEdit& LyricEdit::getInstance() {
  static LyricEdit lc;
  return lc;
}

void LyricEdit::run(std::string autoloadMusicPath) {
  SetConfigFlags(FLAG_WINDOW_RESIZABLE);
  InitWindow(1280, 720, "LyricEdit");
  InitAudioDevice();

  rlImGuiSetup(true);

  auto& io = ImGui::GetIO();
  auto& style = ImGui::GetStyle();
  io.IniFilename = nullptr;

  if (!autoloadMusicPath.empty())
    loadMusic(autoloadMusicPath);

  while (!WindowShouldClose()) {
    if (!music.path.empty())
      UpdateMusicStream(music.raylibResource);
    BeginDrawing();
    ClearBackground(BLACK);

    draw();

    rlImGuiBegin();
    drawImGui();
    rlImGuiEnd();

    EndDrawing();
  }

  rlImGuiShutdown();
  CloseAudioDevice();
  CloseWindow();
}

void LyricEdit::sortLyricsArray() {
  std::sort(lyrics.begin(), lyrics.end(),
            [](const LyricLine& a, const LyricLine& b) -> bool { return a.time < b.time; });
}