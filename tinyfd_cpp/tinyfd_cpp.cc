#include "tinyfd_cpp.hh"
#include "tinyfiledialogs.h"

void tinyfd::openFileDialog(std::string title, std::string defaultPathAndFile,
                            std::vector<std::string> fillerPatterns) {
  char const* const aTitle = title.c_str();
  char const* const aDefaultPathAndFile = defaultPathAndFile.c_str();
  int const aNumOfFilterPatterns = fillerPatterns.size();
  char** aFilterPatterns;
  if (fillerPatterns.empty())
    aFilterPatterns = nullptr;
  else {
    aFilterPatterns = new char*[fillerPatterns.size()];
    for (size_t i = 0; i < fillerPatterns.size(); i++) {
      aFilterPatterns[i] = const_cast<char*>(fillerPatterns[i].c_str());
    }
  }
  tinyfd_openFileDialog(aTitle, aDefaultPathAndFile, aNumOfFilterPatterns, aFilterPatterns, nullptr,
                        0);
}