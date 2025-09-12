#include "LyricEdit.hh"

#include <imgui.h>
#include <raylib.h>
#include <rlImGui.h>

using namespace lc;

LyricEdit::LyricEdit() = default;
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