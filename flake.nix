{
  description = "lyricedit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

        zigDeps = pkgs.callPackage ./build.zig.zon.nix { };

        submodulesDeps = pkgs.linkFarm "submodules-deps" [
          {
            name = "dear_bindings";
            path = pkgs.fetchgit {
              url = "https://github.com/dearimgui/dear_bindings";
              rev = "ec09a883592857d038e82ec618b079cd260a0919";
              hash = "sha256-MWtUNckSozZebT5GuDGB8tXCorEVYTWv2+S7nJYdcpg=";
            };
          }
          {
            name = "imgui";
            path = pkgs.fetchgit {
              url = "https://github.com/ocornut/imgui";
              rev = "f36c65661c5534e215120eb96b7a2455ef1efc82";
              hash = "sha256-9JZ2KQHlJTfAq3SXm6w8DbMY3xqyB7BbQI0LInwMpcA=";
            };
          }
          {
            name = "rlImGui";
            path = pkgs.fetchgit {
              url = "https://github.com/raylib-extras/rlImGui";
              rev = "4d8a61842903978bc42adf3347cd34f4e6524efc";
              hash = "sha256-7ej2+5nxQskBEZhLgIifV78loI8uUM5EVzrSJg9xCc8=";
            };
          }
          {
            name = "libtinyfiledialogs";
            path = pkgs.fetchgit {
              url = "https://git.code.sf.net/p/tinyfiledialogs/code";
              rev = "db67fa7e6f5d893551079c5dd0b1ddd1faeeb8b7";
              hash = "sha256-+qDWoR13+xA6sLYI9DETW/ZN1rDXgUtel46R+/nJgMM=";
            };
          }
        ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          name = "lyricedit";
          version = "0.1.0";

          src = self;

          desktopItem = pkgs.makeDesktopItem {
            name = "lyricedit";
            desktopName = "LyricEdit";
            comment = "";
            exec = "lyricedit";
            terminal = false;
            type = "Application";
            categories = [
              "Audio"
            ];
          };

          libPaths = pkgs.lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.alsa-lib
          ];

          buildInputs = [
            pkgs.makeWrapper
            pkgs-unstable.zig_0_17
            pkgs.libx11
            pkgs.libxrandr
            pkgs.libxinerama
            pkgs.libxcursor
            pkgs.libxi
            pkgs.libGL
            pkgs.python314
            pkgs.python314Packages.ply
          ];

          configurePhase = ''
            rm -rf external
            ln -sf ${submodulesDeps} external
          '';

          buildPhase = ''
            mkdir -p "$out/bin"
            mkdir -p "$out/.cache/zig/p"

            export ZIG_GLOBAL_CACHE_DIR="$out/.cache/zig"
            export PACKAGE_DIR=${zigDeps}

            zig build -Doptimize=ReleaseSmall --system $PACKAGE_DIR

            mv "zig-out/bin/lyricedit" "$out/bin"

            mv "$out/bin/lyricedit" "$out/bin/lyricedit-real"
            makeWrapper "$out/bin/lyricedit-real" "$out/bin/lyricedit" --set LD_LIBRARY_PATH "${libPaths}"

            mkdir -p "$out/share/applications"
            cp "${desktopItem}/share/applications/lyricedit.desktop" "$out/share/applications"
          '';

          installPhase = ":";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs-unstable.zig_0_17
            pkgs.libx11
            pkgs.libxrandr
            pkgs.libxinerama
            pkgs.libxcursor
            pkgs.libxi
            pkgs.libGL
            pkgs.zon2nix
            pkgs.python314
            pkgs.python314Packages.ply
          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.alsa-lib
          ];
        };
      }
    );
}
