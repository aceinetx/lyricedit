#include "../LyricEdit.hh"
#include "../Util.hh"
#include <imgui.h>
#include <imgui_stdlib.h>

using namespace lc;

void LyricEdit::drawEditWindowContent() {
  ImGui::SeparatorText("LRC Metadata");

  auto resize = [this](...) { ImGui::SetNextItemWidth(leftSideWindowsWidth / 1.5f); };

  resize();
  ImGui::InputText("Song title", &lrc.songTitle);
  resize();
  ImGui::InputText("Artist", &lrc.artist);
  resize();
  ImGui::InputText("Album", &lrc.album);
  resize();
  ImGui::InputText("Author", &lrc.author);
  resize();
  ImGui::InputText("Lyricist", &lrc.lyricist);
  resize();
  ImGui::InputText("LRC Author", &lrc.lrcAuthor);

  ImGui::SeparatorText("Lyrics");
  if (ImGui::Button("Add line at current time")) {
    LyricLine line;
    line.time = GetMusicTimePlayed(music.raylibResource);
    line.text = LC_FORMAT("Lyric {}", lrc.lyrics.size() + 1);
    lrc.lyrics.push_back(line);
    sortLyricsArray();
  }
}