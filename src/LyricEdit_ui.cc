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
  float prevWindowHeight;
  static auto& io = ImGui::GetIO();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, 0});
  ImGui::Begin("File", nullptr, defaultWindowFlags);
  drawFileWindowContent();
  prevWindowHeight = ImGui::GetWindowHeight();
  ImGui::End();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, prevWindowHeight});
  ImGui::Begin("Song controls", nullptr, defaultWindowFlags);
  drawSongControlsWindowContent();
  prevWindowHeight = ImGui::GetWindowHeight();
  ImGui::End();

  ImGui::SetNextWindowPos({defaultWindowWidth, 0});
  ImGui::SetNextWindowSize({io.DisplaySize.x - defaultWindowWidth, io.DisplaySize.y});
  ImGui::Begin("Lyrics", nullptr,
               ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse);
  drawLyricsWindowContent();
  ImGui::End();
}
