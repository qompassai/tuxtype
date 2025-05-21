# ~/.GH/Qompass/TuxType/flake.nix
# -------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

{
  description = "Qompass AI TuxType on NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.autoconf
        pkgs.automake
        pkgs.libtool
        pkgs.pkg-config
        pkgs.gcc
        pkgs.SDL
        pkgs.SDL_image
        pkgs.SDL_mixer
        pkgs.SDL_ttf
        pkgs.gettext
        pkgs.gtk2
      ];
      shellHook = ''
        echo "Ready to build TuxType!"
        echo "Run: ./autogen.sh && ./configure && make"
      '';
    };
  };
}

