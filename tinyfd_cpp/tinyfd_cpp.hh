#pragma once
/**
 * TinyFileDialogs wrapper for C++
 *
 * This file is a part of lyricedit
 */
#include <string>
#include <vector>

namespace tinyfd {
std::string openFileDialog(std::string title, std::string defaultPathAndOrFile,
                           std::vector<std::string> filterPatterns,
                           std::string singleFilterDescription);
std::string saveFileDialog(std::string title, std::string defaultPathAndOrFile,
                           std::vector<std::string> filterPatterns,
                           std::string singleFilterDescription);
} // namespace tinyfd