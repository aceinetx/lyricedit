#include "../LyricEdit.hh"
#include "../Util.hh"
#include <imgui.h>
#include <imgui_stdlib.h>

using namespace lc;

void LyricEdit::drawEditWindowContent() {
  ImGui::SeparatorText("LRC Metadata");
  ImGui::InputText("Song title", &lrc.songTitle);
  ImGui::InputText("Artist", &lrc.artist);
  ImGui::InputText("Album", &lrc.album);
  ImGui::InputText("Author", &lrc.author);
  ImGui::InputText("Lyricist", &lrc.lyricist);
  ImGui::InputFloat("Length (seconds)", &lrc.length);
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