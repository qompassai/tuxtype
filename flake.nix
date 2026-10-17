# ~/.GH/Qompass/TuxType/flake.nix
# -------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
#
# Rebuilt 2026-10-17 (Decision 7, Matt 2026-10-16): the previous flake
# was a Rust template (buildRustPackage over a Cargo.lock that does not
# exist) laid over this C/autotools project, so it could not even
# evaluate. This flake packages what the repo actually is:
#   - libt4k_common: the tux4kids common library tuxtype's configure
#     requires (nixpkgs' t4kcommon, exposed under its upstream name);
#   - tuxtype: Tux Typing 1.8.3 built from this tree with the
#     autotools stack (autoreconfHook) and its SDL 1.2 dependencies.

{
  description = "TuxType - Tux Typing (C/autotools) with libt4k_common";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # libt4k_common (https://github.com/tux4kids/t4kcommon):
        # required by configure.ac via PKG_CHECK_MODULES([T4K_COMMON]).
        # Packaged from a pinned upstream rev rather than nixpkgs'
        # t4kcommon 0.1.1: tuxtype 1.8.3 calls T4K_Tts_say, which only
        # exists in the newer library (TTS via espeak-ng).
        libt4k_common = pkgs.stdenv.mkDerivation {
          pname = "libt4k_common";
          version = "0.1.1-unstable-9fd11c1";
          src = pkgs.fetchFromGitHub {
            owner = "tux4kids";
            repo = "t4kcommon";
            rev = "9fd11c1bd1b78fc84141fc32cd9755f373eafae3";
            hash = "sha256-pVLQ8Y2SRm3dunjh5qQsruTZw5W05KyvEZWTCeIHF98=";
          };
          nativeBuildInputs = with pkgs; [
            autoreconfHook
            pkg-config
            gettext
            intltool
          ];
          buildInputs = with pkgs; [
            SDL
            SDL_Pango
            SDL_image
            SDL_mixer
            SDL_net
            SDL_ttf
            cairo
            espeak-ng
            libpng
            librsvg
            libxml2
          ];
          env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types";
          # Same upstream configure.ac typo as tuxtype's: $SDL_IMAGE
          # (empty) instead of $SDL_IMAGE_CFLAGS.
          postPatch = ''
            sed -i 's/\$SDL_IMAGE"/$SDL_IMAGE_CFLAGS"/' configure.ac
            # Upstream master bug: t4k_menu.c declares
            # 'void set_font_size();' (unprototyped) but defines it
            # with a (bool) prototype; the two conflict in every C
            # standard (bool is not promotion-compatible). Give the
            # declaration the prototype it always needed.
            sed -i 's/void            set_font_size();/void            set_font_size(bool);/' src/t4k_menu.c
          '';
          meta = with pkgs.lib; {
            description = "Common library for Tux4Kids programs (libt4k_common)";
            homepage = "https://github.com/tux4kids/t4kcommon";
            license = licenses.gpl3Plus;
          };
        };

        tuxtype = pkgs.stdenv.mkDerivation {
          pname = "tuxtype";
          version = "1.8.3";
          src = ./.;

          # data/scripts/*.sh carry #!/bin/bash shebangs, absent in
          # the nix build sandbox.
          postPatch = ''
            patchShebangs data
            # Upstream configure.ac typo (line ~80): CFLAGS is extended
            # with $SDL_IMAGE (empty) instead of $SDL_IMAGE_CFLAGS, so
            # the SDL_image include dir never reaches the compiler and
            # the build dies on SDL_image.h with per-package prefixes.
            sed -i 's/\$SDL_IMAGE"/$SDL_IMAGE_CFLAGS"/' configure.ac
            # install-data-hook creates the state dir setgid (2755),
            # which the nix sandbox forbids; 0755 is equivalent here.
            sed -i 's/2755/0755/g' Makefile.am
            # doc/Makefile.am distributes files the release tarball
            # ships in doc/ but the git tree does not; provide them
            # (real content where the tree has it, placeholders for
            # the rest) plus the root ABOUT-NLS it references.
            touch ABOUT-NLS AUTHORS
            cp LICENSE doc/COPYING
            cp README.md doc/README
            touch doc/AUTHORS doc/ChangeLog doc/INSTALL doc/OFL doc/TODO
          '';

          # Legacy C89-era sources: several T4K_* functions are used
          # without declarations (globals.h never includes
          # t4k_common.h). GCC 14 makes implicit declarations an
          # error; downgrade the legacy-C diagnostics to warnings,
          # matching how this code built for two decades.
          env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=implicit-int -Wno-error=int-conversion -Wno-error=incompatible-pointer-types";

          nativeBuildInputs = with pkgs; [
            autoreconfHook
            pkg-config
            gettext
            intltool
          ];

          buildInputs = with pkgs; [
            SDL
            SDL_Pango
            SDL_image
            SDL_mixer
            SDL_net
            SDL_ttf
            cairo
            libt4k_common
            librsvg
            libxml2
          ];

          meta = with pkgs.lib; {
            description = "Tux Typing - educational typing tutor for children";
            homepage = "https://github.com/qompassai/tuxtype";
            license = licenses.gpl3Plus;
            mainProgram = "tuxtype";
          };
        };
      in
      {
        packages = {
          default = tuxtype;
          inherit tuxtype libt4k_common;
        };

        apps.default = flake-utils.lib.mkApp { drv = tuxtype; };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ tuxtype ];
        };
      });
}
