# ~/.GH/Qompass/TuxType/flake.nix
# -------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved

{
  description = "QompassAI on TuxType";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Native builds for Linux/macOS/Windows
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          targets = [ 
            "aarch64-linux-android" 
            "x86_64-linux-android"
          ];
        };
        tuxtype = pkgs.rustPlatform.buildRustPackage {
          pname = "tuxtype";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          nativeBuildInputs = [ rustToolchain ];
          CARGO_BUILD_TARGET = if pkgs.stdenv.hostPlatform.isWindows
            then "x86_64-pc-windows-gnu"
            else null;
        };
      in {
        packages.default = tuxtype;
        apps.default = flake-utils.lib.mkApp { drv = tuxtype; };
      }
    ) // {
      packages = let
        androidSystems = {
          aarch64-android = "aarch64-unknown-linux-android";
          x86_64-android = "x86_64-unknown-linux-android";
        };
        mkAndroidPackage = androidSystem: androidTarget:
          let
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              crossSystem = {
                config = androidTarget;
                useAndroidPrebuilt = true;
              };
            };
          in
            pkgs.rustPlatform.buildRustPackage {
              pname = "tuxtype";
              version = "0.1.0";
              src = ./.;
              cargoLock.lockFile = ./Cargo.lock;
              nativeBuildInputs = [ pkgs.androidndk ];
              ANDROID_NDK_ROOT = "${pkgs.androidndk}/libexec/android-sdk/ndk-bundle";
            };
      in
        builtins.mapAttrs
          (name: target: { default = mkAndroidPackage name target; })
          androidSystems;
    };
}
