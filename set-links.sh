#!/usr/bin/env bash
# Symlinks every file/folder in this directory into $HOME.
# Safe to re-run: skips anything already correctly linked, warns instead of
# overwriting anything else. Pass -f to force-overwrite conflicting targets.

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE=0
[[ "${1:-}" == "-f" ]] && FORCE=1

IGNORE_FILE="$SRC_DIR/.install-ignore"
ignored() {
    local name="$1"
    [[ -f "$IGNORE_FILE" ]] || return 1
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        [[ "$name" == "$line" ]] && return 0
    done < "$IGNORE_FILE"
    return 1
}

for entry in "$SRC_DIR"/* "$SRC_DIR"/.[!.]*; do
    [[ -e "$entry" ]] || continue
    name="$(basename "$entry")"
    ignored "$name" && continue

    target="$HOME/$name"

    if [[ -L "$target" ]]; then
        if [[ "$(readlink "$target")" == "$entry" ]]; then
            echo "ok: $target already linked"
            continue
        elif [[ "$FORCE" == 1 ]]; then
            rm "$target"
        else
            echo "skip: $target is a symlink to something else ($(readlink "$target"))"
            continue
        fi
    elif [[ -e "$target" ]]; then
        if [[ "$FORCE" == 1 ]]; then
            rm -rf "$target"
        else
            echo "skip: $target already exists (not a symlink)"
            continue
        fi
    fi

    ln -s "$entry" "$target"
    echo "linked: $target -> $entry"
done
