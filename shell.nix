# ~/.GH/Qompass/TuxType/shell.nix
# -------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
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
}

