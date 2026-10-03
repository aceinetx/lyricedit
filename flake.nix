{
  description = "lyricedit";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "lyricedit";
          version = "0.1.0";

          src = self;

          buildInputs = with pkgs; [
            makeWrapper
            zig
            libx11
            libxrandr
            libxinerama
            libxcursor
            libxi
            libGL
          ];

          configurePhase = ":";

          buildPhase = ''
            mkdir -p "$out/bin"

            mkdir build
            cd build
            cmake ..
            make -j$(nproc)

            cp lyricedit "$out/bin"
            	  '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zig
            libx11
            libxrandr
            libxinerama
            libxcursor
            libxi
            libGL
          ];
          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.alsa-lib
          ];

          #shellHook = ''
          #  export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH}''${LD_LIBRARY_PATH:+:}${pkgs.libglvnd}/lib"
          #'';
        };
      }
    );
}
