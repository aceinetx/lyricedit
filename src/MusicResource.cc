#include "MusicResource.hh"
#include "Util.hh"

using namespace lc;

std::string MusicResource::getTimeFormatted() {
  return Util::formatTimeFloatSeconds(GetMusicTimePlayed(raylibResource));
}