#include "LyricEdit.hh"

#include "LyricLine.hh"
#include <algorithm>
#include <imgui.h>
#include <raylib.h>
#include <rlImGui.h>

using namespace lc;

LyricEdit::LyricEdit() {
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
  io.Fonts->ClearFonts();
  io.Fonts->AddFontFromFileTTF("./assets/font.ttf", 18.0f, nullptr,
                               io.Fonts->GetGlyphRangesDefault());

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
  std::sort(lrc.lyrics.begin(), lrc.lyrics.end(),
            [](const LyricLine& a, const LyricLine& b) -> bool { return a.time < b.time; });
}