#pragma once
#include "../LyricLine.hh"
#include <vector>

namespace lc {
namespace LRCDeserializer {
std::vector<LyricLine> deserialize(std::string lrc);
}
} // namespace lc
