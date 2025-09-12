#include "../LyricEdit.hh"
#include <imgui.h>

using namespace lc;

void LyricEdit::drawFileWindowContent() {
  ImGui::SeparatorText("Open");
  if (ImGui::Button("Open .mp3")) {
    openMusicDialog();
  }
  ImGui::SameLine();
  if (ImGui::Button("Open .lrc")) {
    openLRCDialog();
  }

  ImGui::SeparatorText("Save");
  if (ImGui::Button("Save .lrc")) {
    saveLRCDialog();
  }
}