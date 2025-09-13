#include "LyricEdit.hh"
#include <imgui.h>
#include <raylib.h>

using namespace lc;

void LyricEdit::draw() {
}

void LyricEdit::drawImGui() {
  constexpr ImGuiWindowFlags defaultWindowFlags =
      ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse;
  float prevWindowEndY;
  static auto& io = ImGui::GetIO();

  ImGui::SetNextWindowSize({leftSideWindowsWidth, 0});
  ImGui::SetNextWindowPos({0, 0});
  ImGui::Begin("File", nullptr, defaultWindowFlags);
  drawFileWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowSize({leftSideWindowsWidth, 0});
  ImGui::SetNextWindowPos({0, prevWindowEndY});
  ImGui::Begin("Song controls", nullptr, defaultWindowFlags);
  drawSongControlsWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowSize({leftSideWindowsWidth, io.DisplaySize.y - prevWindowEndY});
  ImGui::SetNextWindowPos({0, prevWindowEndY});
  ImGui::Begin("Edit", nullptr, defaultWindowFlags);
  drawEditWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowPos({leftSideWindowsWidth, 0});
  ImGui::SetNextWindowSize({io.DisplaySize.x - leftSideWindowsWidth, io.DisplaySize.y});
  ImGui::Begin("Lyrics", nullptr,
               ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize);
  drawLyricsWindowContent();

  ImGui::End();
}
