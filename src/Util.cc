#include "Util.hh"
#include <iomanip>
#include <sstream>

using namespace lc;

std::string Util::formatTimeFloatSeconds(float seconds) {
  if (seconds < 0)
    seconds = 0;
  int total_ms = static_cast<int>(seconds * 1000 + 0.5);
  int mins = total_ms / 60000;
  int secs = (total_ms / 1000) % 60;
  int centis = (total_ms % 1000) / 10;
  std::ostringstream oss;
  oss << std::setw(2) << std::setfill('0') << mins << ':' << std::setw(2) << std::setfill('0')
      << secs << '.' << std::setw(2) << std::setfill('0') << centis;
  return oss.str();
}

std::vector<std::string> Util::split(std::string s, std::string delimiter) {
  std::vector<std::string> tokens;
  size_t pos = 0;
  std::string token;
  while ((pos = s.find(delimiter)) != std::string::npos) {
    token = s.substr(0, pos);
    tokens.push_back(token);
    s.erase(0, pos + delimiter.length());
  }
  tokens.push_back(s);

  return tokens;
}