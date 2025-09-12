#pragma once
#include <format>
#include <string>
#include <vector>

#define LC_FORMAT(...) std::format(__VA_ARGS__)
#define LC_FORMAT_C(...) LC_FORMAT(__VA_ARGS__).c_str()

namespace lc {
namespace Util {
std::string formatTimeFloatSeconds(float seconds);
std::vector<std::string> split(std::string s, std::string delimiter);
} // namespace Util
}; // namespace lc