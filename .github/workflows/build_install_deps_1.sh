#!/usr/bin/env bash

sudo apt update
sudo apt-get install -y --no-install-recommends \
  libgl-dev                                     \
  libx11-dev                                    \
  libxrandr-dev                                 \
  libxinerama-dev                               \
  libxi-dev                                     \
  libxcursor-dev                                \
  python3                                       \
  python3-pip                                   \
  python-is-python3
pip install ply
