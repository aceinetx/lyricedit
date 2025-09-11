#include "lyricedit.hh"

#include <imgui.h>
#include <raylib.h>
#include <rlImGui.h>

using namespace lc;

LyricEdit::LyricEdit() = default;

LyricEdit& LyricEdit::getInstance() {
  static LyricEdit lc;
  return lc;
}

void LyricEdit::run() {
  InitWindow(1280, 720, "LyricEdit");

  rlImGuiSetup(true);

  auto& io = ImGui::GetIO();
  io.IniFilename = nullptr;

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(BLACK);

    draw();

    rlImGuiBegin();
    drawImGui();
    rlImGuiEnd();

    EndDrawing();
  }

  rlImGuiShutdown();

  CloseWindow();
}