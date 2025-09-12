#include "LyricEdit.hh"
#include "Util.hh"
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
  if (ImGui::Button("Open .mp3")) {
    openMusicDialog();
  }
  ImGui::Button("Open .lrc");
  prevWindowHeight = ImGui::GetWindowHeight();
  ImGui::End();

  ImGui::SetNextWindowSize({defaultWindowWidth, 0});
  ImGui::SetNextWindowPos({0, prevWindowHeight});
  ImGui::Begin("Song controls", nullptr, defaultWindowFlags);

  if (!music.path.empty()) {
    ImGui::Text("%s", music.getTimeFormatted().c_str());

    if (ImGui::Button("Play"))
      playMusic();
    ImGui::SameLine();
    if (ImGui::Button("Stop"))
      stopMusic();

    if (ImGui::Button("Pause/Resume")) {
      if (IsMusicStreamPlaying(music.raylibResource))
        pauseMusic();
      else
        resumeMusic();
    }
    ImGui::SameLine();
  } else {
    ImGui::Text("Load a song first");
  }

  ImGui::End();
}