#include "../LyricEdit.hh"
#include "../Util.hh"
#include <cstdlib>
#include <cstring>
#include <imgui.h>

#define LC_UNIQUE(title) (LC_FORMAT_C("{}##{}", title, lyric.getHash()))
#define LC_UNIQUE_EX(title, id) (LC_FORMAT_C("{}##{}{}", title, lyric.getHash(), id))

using namespace lc;

void LyricEdit::drawLyricsWindowContent() {
  static auto& io = ImGui::GetIO();
  static size_t editingLyricIndex = -1;
  static char editingLyricText[2048];

  bool sortLyrics = false;
  float musicTimePlayed = GetMusicTimePlayed(music.raylibResource);

  if (ImGui::Button("Add line at current time")) {
    LyricLine line;
    line.time = GetMusicTimePlayed(music.raylibResource);
    line.text = "(New lyric line, edit this)";
    line.updateHash();
    lyrics.push_back(line);
    sortLyricsArray();
  }

  ImGui::Separator();

  // Find current lyric time
  size_t currentLyricIndex = 0;
  if (!lyrics.empty())
    for (size_t i = lyrics.size() - 1; i > 0; i--) {
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
      if (ImGui::InputText(LC_UNIQUE_EX("", "text"), editingLyricText, sizeof editingLyricText)) {
        lyric.text = editingLyricText;
        lyric.updateHash();
      }
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
      if (isEditing)
        editingLyricIndex = -1;
      else {
        std::memset(editingLyricText, 0, sizeof editingLyricText);
        std::strncpy(editingLyricText, lyric.text.c_str(), sizeof editingLyricText - 1);
        editingLyricIndex = i;
      }
    }

    ImGui::Spacing();
  }

  if (sortLyrics)
    sortLyricsArray();
}