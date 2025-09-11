#include "lyricedit.hh"
#include <imgui.h>
#include <raylib.h>

using namespace lc;

void LyricEdit::draw() {
}

void LyricEdit::drawImGui() {
  constexpr float defaultWindowWidth = 150;
  constexpr ImGuiWindowFlags defaultWindowFlags =
      ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse;
  float prevWindowHeight;

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, 0});
  ImGui::Begin("File", nullptr, defaultWindowFlags);
  ImGui::Button("Open .mp3");
  ImGui::Button("Open .lrc");
  prevWindowHeight = ImGui::GetWindowHeight();
  ImGui::End();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, prevWindowHeight});
  ImGui::Begin("Song controls", nullptr, defaultWindowFlags);

  ImGui::Text("00:00.00");

  ImGui::Button("Play");
  ImGui::SameLine();
  ImGui::Button("Stop");

  ImGui::Button("Pause");
  ImGui::SameLine();
  ImGui::Button("Resume");

  ImGui::End();
}