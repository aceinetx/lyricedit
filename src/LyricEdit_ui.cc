#include "LyricEdit.hh"
#include <imgui.h>
#include <raylib.h>

using namespace lc;

void LyricEdit::draw() {
}

void LyricEdit::drawImGui() {
  constexpr float defaultWindowWidth = 300;
  constexpr ImGuiWindowFlags defaultWindowFlags =
      ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse;
  float prevWindowEndY;
  static auto& io = ImGui::GetIO();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, 0});
  ImGui::Begin("File", nullptr, defaultWindowFlags);
  drawFileWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, prevWindowEndY});
  ImGui::Begin("Song controls", nullptr, defaultWindowFlags);
  drawSongControlsWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowSize({defaultWindowWidth, io.DisplaySize.y - prevWindowEndY});
  ImGui::SetNextWindowPos({0, prevWindowEndY});
  ImGui::Begin("Edit", nullptr, defaultWindowFlags);
  drawEditWindowContent();
  prevWindowEndY = ImGui::GetWindowHeight() + ImGui::GetWindowPos().y;
  ImGui::End();

  ImGui::SetNextWindowPos({defaultWindowWidth, 0});
  ImGui::SetNextWindowSize({io.DisplaySize.x - defaultWindowWidth, io.DisplaySize.y});
  ImGui::Begin("Lyrics", nullptr,
               ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse);
  drawLyricsWindowContent();
  ImGui::End();
}
