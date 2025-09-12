#pragma once
#include "../LyricLine.hh"
#include <vector>

namespace lc {
namespace LRCSerailizer {
std::string serialize(std::vector<LyricLine> lines);
}
} // namespace lc