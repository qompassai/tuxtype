#!/usr/bin/env sh
# /qompassai/tuxtype/cross-configure.sh
# ------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
set -eu

: "${PREFIX:=${HOME}/.local/mingw}"
: "${TARGET:=i686-w64-mingw32}"
: "${BUILD_DIR:=build-cross}"
: "${CONFIG_SHELL:=/bin/sh}"

export CONFIG_SHELL
export PATH="${PREFIX}/bin:${PREFIX}/${TARGET}/bin:${PATH}"

SDL_CONFIG="${PREFIX}/${TARGET}/bin/${TARGET}-sdl-config"
[ -x "${SDL_CONFIG}" ] && export SDL_CONFIG

mkdir -p "${BUILD_DIR}"
trap 'rm -rf "${BUILD_DIR}"' EXIT INT TERM

check_deps() {
    for cmd in make "${TARGET}-gcc"; do
        command -v "${cmd}" >/dev/null 2>&1 || {
            echo >&2 "Error: Missing required tool '${cmd}'"
            exit 1
        }
    done
}

configure() {
    cd "${BUILD_DIR}"

    CPPFLAGS="-I${PREFIX}/${TARGET}/include"
    LDFLAGS="-L${PREFIX}/${TARGET}/lib"
    export CPPFLAGS LDFLAGS

    "${CONFIG_SHELL}" ../configure \
        --cache-file="config.cache" \
        --target="${TARGET}" \
        --host="${TARGET}" \
        --build="$(gcc -dumpmachine)" \
        --prefix="${PREFIX}/${TARGET}" \
        --disable-static \
        "$@"
}

main() {
    check_deps
    configure "$@"
}

main "$@"
