"""Validation gate for the qompassai/tuxtype repository.

The repo is upstream Tux Typing 1.8.3 (autotools C game,
24 sources in src/, SDL 1.2) plus Qompass AI's packaging layer.
Upstream ships no test suite, so these tests gate what exists:

- the autotools project definition (AC_INIT identity, the
  AC_CONFIG_SRCDIR sentinel, the data tree the game loads);
- the build system's first real step — `autoreconf -fi` in a
  scratch copy must generate a working `configure` script.
  (A full build is blocked upstream of this repo: configure
  requires libt4k_common, a separate tux4kids library that is
  not vendored here; measured on primo 2026-10-16.)
- the Nix flake is a KNOWN FAILURE, kept as a strict xfail:
  flake.nix is a Rust template (buildRustPackage over a
  Cargo.lock) laid over a C/autotools project, so evaluation
  fails on the missing Cargo.lock. Strict xfail means the day
  the flake is fixed — or removed — this suite goes red until
  the marker is removed.

Run: python3 -m pytest tests/ -q
"""

from __future__ import annotations

import re
import shutil
import subprocess
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SUBPROCESS_TIMEOUT_S = 240
AC_INIT_RE = re.compile(
    r'AC_INIT\(\s*\[([^\]]+)\]\s*,\s*\[([^\]]+)\]\s*,\s*\[[^\]]*\]\s*,\s*\[([^\]]+)\]\s*\)'
)
SRCDIR_RE = re.compile(r'AC_CONFIG_SRCDIR\(\s*\[([^\]]+)\]\s*\)')
MIN_CONFIGURE_BYTES = 100_000


def _parse_ac_init(text: str) -> tuple[str, str, str] | None:
    """Extract (name, version, tarname) from AC_INIT, or None."""
    match = AC_INIT_RE.search(text)
    if match is None:
        return None
    return match.group(1), match.group(2), match.group(3)


def _validate_data_tree(root: Path) -> list[str]:
    """The data files the game loads at runtime must be present."""
    problems: list[str] = []
    for subdir in ('images', 'fonts'):
        path = root / 'data' / subdir
        if not path.is_dir() or not any(path.iterdir()):
            problems.append(f'data/{subdir} missing or empty')
    for name in ('keyboard.lst', 'phrases.txt'):
        path = root / 'data' / name
        if not path.is_file() or path.stat().st_size == 0:
            problems.append(f'data/{name} missing or empty')
    return problems


# --- Validation ---


def test_configure_ac_identity() -> None:
    text = (REPO_ROOT / 'configure.ac').read_text(encoding='utf-8')
    assert _parse_ac_init(text) == ('Tux Typing', '1.8.3', 'tuxtype')
    match = SRCDIR_RE.search(text)
    assert match is not None
    assert (REPO_ROOT / match.group(1)).is_file(), 'AC_CONFIG_SRCDIR sentinel missing'


def test_c_sources_present() -> None:
    sources = sorted((REPO_ROOT / 'src').glob('*.c'))
    assert len(sources) >= 20, 'expected the upstream C source set'
    for path in sources:
        assert path.stat().st_size > 0, path


def test_data_tree_is_complete() -> None:
    assert _validate_data_tree(REPO_ROOT) == []


def test_autoreconf_generates_configure(tmp_path: Path) -> None:
    """The build system's first step must succeed from a clean copy."""
    if shutil.which('autoreconf') is None:
        pytest.skip('autoreconf not installed')
    work = tmp_path / 'tree'
    shutil.copytree(
        REPO_ROOT,
        work,
        ignore=shutil.ignore_patterns('.git', 'tests', '__pycache__'),
    )
    result = subprocess.run(
        ['autoreconf', '-fi'],
        cwd=work,
        capture_output=True,
        text=True,
        timeout=SUBPROCESS_TIMEOUT_S,
        check=False,
    )
    assert result.returncode == 0, result.stderr[-2000:]
    configure = work / 'configure'
    assert configure.is_file() and configure.stat().st_size > MIN_CONFIGURE_BYTES


# --- Adversarial ---


def test_ac_init_parser_rejects_garbage() -> None:
    assert _parse_ac_init('AC_INIT nothing here') is None
    assert _parse_ac_init('') is None


def test_ac_init_parser_reads_mutated_values() -> None:
    text = (REPO_ROOT / 'configure.ac').read_text(encoding='utf-8')
    mutated = text.replace('[1.8.3]', '[9.9.9]', 1)
    parsed = _parse_ac_init(mutated)
    assert parsed is not None and parsed[1] == '9.9.9'
    assert parsed != _parse_ac_init(text)


def test_data_tree_validator_catches_missing_dir(tmp_path: Path) -> None:
    (tmp_path / 'data' / 'fonts').mkdir(parents=True)
    (tmp_path / 'data' / 'fonts' / 'f.ttf').write_bytes(b'x')
    problems = _validate_data_tree(tmp_path)
    assert any('images' in problem for problem in problems)
    assert any('keyboard.lst' in problem for problem in problems)


@pytest.mark.xfail(
    strict=True,
    reason=(
        'flake.nix is a Rust template over a C/autotools project: '
        'evaluation fails because ./Cargo.lock does not exist. '
        "Fixing or removing the flake is Matt's packaging call."
    ),
)
def test_flake_evaluates() -> None:
    if shutil.which('nix') is None:
        pytest.skip('nix not installed')
    result = subprocess.run(
        ['nix', 'flake', 'check', '--no-build', 'path:.'],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
        timeout=SUBPROCESS_TIMEOUT_S,
        check=False,
    )
    assert result.returncode == 0, result.stderr[-2000:]
