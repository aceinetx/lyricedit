#!/usr/bin/env bash

wget https://ziglang.org/download/0.17.0/zig-x86_64-linux-0.17.0.tar.xz
tar -xvf zig-x86_64-linux-0.17.0.tar.xz
mv zig-x86_64-linux-0.17.0 zig
zig/zig version
