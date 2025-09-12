#pragma once
/**
 * TinyFileDialogs wrapper for C++
 *
 * This file is a part of lyricedit
 */
#include <string>
#include <vector>

namespace tinyfd {
void openFileDialog(std::string title, std::string defaultPathAndFile,
                    std::vector<std::string> fillerPatterns, std::string singleFilterDescription);
}