#include "tinyfd_cpp.hh"
#include "tinyfiledialogs.h"

std::string tinyfd::openFileDialog(std::string title, std::string defaultPathAndOrFile,
                                   std::vector<std::string> filterPatterns,
                                   std::string singleFilterDescription) {
  char const* const aTitle = title.c_str();
  char const* const aDefaultPathAndOrFile = defaultPathAndOrFile.c_str();
  int const aNumOfFilterPatterns = filterPatterns.size();
  char** aFilterPatterns = nullptr;
  if (!filterPatterns.empty()) {
    aFilterPatterns = new char*[filterPatterns.size()];
    for (size_t i = 0; i < filterPatterns.size(); i++) {
      aFilterPatterns[i] = const_cast<char*>(filterPatterns[i].c_str());
    }
  }
  char* raw_result = tinyfd_openFileDialog(aTitle, aDefaultPathAndOrFile, aNumOfFilterPatterns,
                                           aFilterPatterns, singleFilterDescription.c_str(), 0);

  std::string result = raw_result == nullptr ? "" : raw_result;
  if (aFilterPatterns)
    delete[] aFilterPatterns;
  return result;
}
std::string tinyfd::saveFileDialog(std::string title, std::string defaultPathAndOrFile,
                                   std::vector<std::string> filterPatterns,
                                   std::string singleFilterDescription) {
  const char* aTitle = title.c_str();
  const char* aDefaultPathAndOrFile = defaultPathAndOrFile.c_str();
  int aNumOfFilterPatterns = filterPatterns.size();
  char** aFilterPatterns = nullptr;
  if (!filterPatterns.empty()) {
    aFilterPatterns = new char*[filterPatterns.size()];
    for (size_t i = 0; i < filterPatterns.size(); i++) {
      aFilterPatterns[i] = const_cast<char*>(filterPatterns[i].c_str());
    }
  }
  const char* aSingleFilterDescription = singleFilterDescription.c_str();

  char* raw_result = tinyfd_saveFileDialog(aTitle, aDefaultPathAndOrFile, aNumOfFilterPatterns,
                                           aFilterPatterns, aSingleFilterDescription);
  std::string result = raw_result == nullptr ? "" : raw_result;
  if (aFilterPatterns)
    delete[] aFilterPatterns;
  return result;
}