# Wave-1 tail bundle (Decision 7) — 2026-10-17

flake.nix replaced: the Rust template (buildRustPackage over a
nonexistent Cargo.lock) is gone. The new flake is a real C/autotools
flake and packages libt4k_common in the same pass:
- libt4k_common is built from pinned upstream tux4kids/t4kcommon rev
  9fd11c1 (nixpkgs' t4kcommon 0.1.1 predates T4K_Tts_say, which
  tuxtype 1.8.3 calls; TTS via espeak-ng). Packaging shims inside the
  derivation only: the shared upstream configure.ac typo
  ($SDL_IMAGE for $SDL_IMAGE_CFLAGS) and an upstream master bug
  (unprototyped set_font_size() vs its bool definition) are sed-fixed
  at build time; the vendored tree is untouched.
- tuxtype builds from this tree (autoreconfHook, SDL 1.2 stack).
  Shims: patchShebangs over data/, the doc/ dist files the tarball
  ships but git lacks, the same $SDL_IMAGE typo, legacy-C diagnostic
  downgrades for GCC 14, and the install hook's setgid state dir
  (2755 -> 0755, forbidden in the sandbox).
Gate: nix flake check --no-build clean; nix build .#libt4k_common
and .#tuxtype both produce outputs; pytest suite green with the
former strict xfail flipped to real passes.
