#pragma once
#include "../LyricLine.hh"
#include <vector>

namespace lc {
namespace LRCDeserailizer {
std::vector<LyricLine> deserialize(std::string lrc);
}
} // namespace lc
