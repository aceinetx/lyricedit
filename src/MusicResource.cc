#include "MusicResource.hh"
#include "Util.hh"

using namespace lc;

int MusicResource::getPlayedTimeMilliseconds() {
  int total_ms = static_cast<int>(GetMusicTimePlayed(raylibResource) * 1000 + 0.5);
  int centis = (total_ms % 1000) / 10;

  return centis;
}

int MusicResource::getPlayedTimeSeconds() {
  int total_ms = static_cast<int>(GetMusicTimePlayed(raylibResource) * 1000 + 0.5);
  int secs = (total_ms / 1000) % 60;

  return secs;
}

int MusicResource::getPlayedTimeMinutes() {
  int total_ms = static_cast<int>(GetMusicTimePlayed(raylibResource) * 1000 + 0.5);
  int mins = total_ms / 60000;

  return mins;
}

std::string MusicResource::getPlayedTimeFormatted() {
  return Util::formatTimeFloatSeconds(GetMusicTimePlayed(raylibResource));
}