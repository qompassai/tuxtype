#!/usr/bin/env sh
# /qompassai/tuxtype/cross-make.sh
# ------------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
set -eu

: "${PREFIX:=${HOME}/.local/mingw}"
: "${TARGET:=i686-w64-mingw32}"
: "${BUILD_DIR:=${PWD}/build}"

PATH="${PREFIX}/bin:${PREFIX}/${TARGET}/bin:${PATH}"
export PATH

cleanup() {
    rm -rf "${BUILD_DIR}"
}
trap cleanup EXIT INT TERM

check_deps() {
    for cmd in make gcc "${TARGET}-gcc"; do
        command -v "${cmd}" >/dev/null 2>&1 || {
            echo >&2 "Error: Required command '${cmd}' not found"
            exit 1
        }
    done
}

build() {
    check_deps

    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"

    ../configure \
        --host="${TARGET}" \
        --prefix="${PREFIX}" \
        --bindir="${PREFIX}/bin" \
        --disable-static

    make -j"$(nproc)"
    make install DESTDIR=
}

main() {
    while [ $# -gt 0 ]; do
        case $1 in
            --prefix=*) PREFIX="${1#*=}"; shift ;;
            --target=*) TARGET="${1#*=}"; shift ;;
            *) break ;;
        esac
    done

    build "$@"
}

main "$@"
