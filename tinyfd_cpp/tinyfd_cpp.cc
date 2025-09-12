#include "tinyfd_cpp.hh"
#include "tinyfiledialogs.h"

std::string tinyfd::openFileDialog(std::string title, std::string defaultPathAndFile,
                                   std::vector<std::string> fillerPatterns,
                                   std::string singleFilterDescription) {
  char const* const aTitle = title.c_str();
  char const* const aDefaultPathAndFile = defaultPathAndFile.c_str();
  int const aNumOfFilterPatterns = fillerPatterns.size();
  char** aFilterPatterns = nullptr;
  if (!fillerPatterns.empty()) {
    aFilterPatterns = new char*[fillerPatterns.size()];
    for (size_t i = 0; i < fillerPatterns.size(); i++) {
      aFilterPatterns[i] = const_cast<char*>(fillerPatterns[i].c_str());
    }
  }
  std::string result = tinyfd_openFileDialog(aTitle, aDefaultPathAndFile, aNumOfFilterPatterns,
                                             aFilterPatterns, singleFilterDescription.c_str(), 0);
  if (aFilterPatterns)
    delete[] aFilterPatterns;
  return result;
}