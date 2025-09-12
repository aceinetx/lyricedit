#include "LyricEdit.hh"

int main(int argc, char** argv) {
  auto& lyricedit = lc::LyricEdit::getInstance();
  if (argc > 1)
    lyricedit.run(argv[1]);
  else
    lyricedit.run();
}