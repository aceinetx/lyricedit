#include "../LyricEdit.hh"
#include <imgui.h>
#include <iostream>

using namespace lc;

void LyricEdit::drawSongControlsWindowContent() {
  if (!music.path.empty()) {
    // * Time
    float time = GetMusicTimePlayed(music.raylibResource);
    float max_time = GetMusicTimeLength(music.raylibResource);
    if (ImGui::SliderFloat("##time", &time, 0, max_time)) {
      SeekMusicStream(music.raylibResource, time);
    }
    ImGui::SameLine();
    ImGui::Text("%s", music.getPlayedTimeFormatted().c_str());

    // * Volume
    static float volume = 1.0f;
    if (ImGui::DragFloat("Volume", &volume, 0.01f)) {
      SetMusicVolume(music.raylibResource, volume);
      if (volume < 0)
        volume = 0;
    }

    // * Play/Stop/Pause/Resume
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
  } else {
    ImGui::Text("Load a song first");
  }
}
