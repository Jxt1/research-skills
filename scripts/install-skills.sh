#!/usr/bin/env bash
set -euo pipefail

skill="${1:-}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
source_root="$repo_root/skills"
codex_home="${CODEX_HOME:-$HOME/.codex}"
target_root="$codex_home/skills"

if [[ ! -d "$source_root" ]]; then
  echo "Missing skills directory: $source_root" >&2
  exit 1
fi

mkdir -p "$target_root"

install_skill() {
  local source_dir="$1"
  local name
  name="$(basename "$source_dir")"

  if [[ ! -f "$source_dir/SKILL.md" ]]; then
    echo "Skipping $name: missing SKILL.md" >&2
    return
  fi

  local target_dir="$target_root/$name"
  mkdir -p "$target_dir"
  cp -R "$source_dir"/. "$target_dir"/
  echo "Installed $name -> $target_dir"
}

if [[ -n "$skill" ]]; then
  if [[ ! -d "$source_root/$skill" ]]; then
    echo "Skill not found: $skill" >&2
    exit 1
  fi
  install_skill "$source_root/$skill"
else
  for source_dir in "$source_root"/*; do
    [[ -d "$source_dir" ]] || continue
    install_skill "$source_dir"
  done
fi

echo "Done. Start a new Codex session to use installed skills."
