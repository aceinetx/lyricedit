#include "../LyricEdit.hh"
#include "../Util.hh"
#include <cstdlib>
#include <cstring>
#include <imgui.h>
#include <imgui_stdlib.h>

#define LC_UNIQUE(title) (LC_FORMAT_C("{}##{}", title, lyric.getUID()))
#define LC_UNIQUE_EX(title, id) (LC_FORMAT_C("{}##{}{}", title, lyric.getUID(), id))

using namespace lc;

void LyricEdit::drawLyricsWindowContent() {
  static auto& io = ImGui::GetIO();
  static size_t editingLyricIndex = -1;
  auto& lyrics = lrc.lyrics;

  bool sortLyrics = false;
  float musicTimePlayed = GetMusicTimePlayed(music.raylibResource);

  // Find current lyric time
  size_t currentLyricIndex = -1;
  if (!lyrics.empty())
    for (int i = lyrics.size() - 1; i >= 0; --i) {
      if (musicTimePlayed >= lyrics[i].time) {
        currentLyricIndex = i;
        break;
      }
    }

  for (size_t i = 0; i < lyrics.size(); i++) {
    auto& lyric = lyrics[i];
    bool isEditing = editingLyricIndex == i;

    ImU32 color = ImGui::ColorConvertFloat4ToU32({0.5f, 0.5f, 0.5f, 1.0f});
    if (i == currentLyricIndex) {
      color = ImGui::ColorConvertFloat4ToU32({1.0f, 1.0f, 1.0f, 1.0f});
    }

    // Push styling
    ImGui::PushFont(NULL, 20.0f);

    if (!isEditing) {
      // Push color
      ImGui::PushStyleColor(ImGuiCol_Text, color);

      ImGui::Text("%s", lyric.text.c_str());

      // Pop color
      ImGui::PopStyleColor();
    } else {
      ImGui::InputText(LC_UNIQUE_EX("", "text"), &lyric.text);
    }

    // Pop styling
    ImGui::PopFont();

    float controlCursorPosY = ImGui::GetCursorPosY() - 20.0f;
    if (isEditing)
      controlCursorPosY -= 6.0f;

    // Time of the lyric
    ImGui::SetCursorPosY(controlCursorPosY + 2.0f);
    ImGui::SetCursorPosX(ImGui::GetWindowWidth() - 70);
    ImGui::Text("%s", Util::formatTimeFloatSeconds(lyric.time).c_str());

    ImGui::SetCursorPosY(controlCursorPosY);
    ImGui::SetCursorPosX(ImGui::GetWindowWidth() - 180.0f);
    ImGui::SetNextItemWidth(100.0f);
    if (ImGui::DragFloat(LC_UNIQUE_EX("", "time"), &lyric.time, 0.01f)) {
      if (lyric.time < 0)
        lyric.time = 0;
      sortLyrics = true;
    }

    // Line control
    // Remove button
    ImGui::SetCursorPosY(controlCursorPosY);
    ImGui::SetCursorPosX(ImGui::GetWindowWidth() - 250);
    if (ImGui::Button(LC_UNIQUE("Remove"))) {
      lyrics.erase(lyrics.begin() + i);
      i--;
      continue;
    }
    // Edit button
    ImGui::SetCursorPosY(controlCursorPosY);
    ImGui::SetCursorPosX(ImGui::GetWindowWidth() - 300);
    if (ImGui::Button(LC_UNIQUE("Edit"))) {
      editingLyricIndex = !isEditing ? i : -1;
    }

    ImGui::Spacing();
  }

  if (sortLyrics)
    sortLyricsArray();
}