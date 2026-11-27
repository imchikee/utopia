#!/usr/bin/env bash
set -euo pipefail

# Utopia-owned mutation-safe marked-block applicator for Starship.
# Noctalia renders starship-palette.toml into $XDG_CACHE_HOME before calling
# this hook. Only the block between the Noctalia markers in starship.toml is
# replaced, preserving the rest of the file and avoiding upstream hook drift.
config_home="${XDG_CONFIG_HOME:-${HOME}/.config}"
cache_home="${XDG_CACHE_HOME:-${HOME}/.cache}"
starship_config="${STARSHIP_CONFIG:-${config_home}/starship.toml}"
palette_file="${cache_home}/noctalia/starship-palette.toml"

begin_marker='# >>> NOCTALIA STARSHIP PALETTE >>>'
end_marker='# <<< NOCTALIA STARSHIP PALETTE <<<'

if [[ ! -s "$palette_file" ]]; then
  printf 'utopia-starship: rendered palette is missing or empty: %s\n' "$palette_file" >&2
  exit 1
fi

if ! grep -qxF '[palettes.noctalia]' "$palette_file" || grep -q '{{' "$palette_file"; then
  printf 'utopia-starship: invalid rendered palette: %s\n' "$palette_file" >&2
  exit 1
fi

if [[ ! -f "$starship_config" ]]; then
  exit 0
fi

target_config="$starship_config"
if [[ -L "$starship_config" ]]; then
  target_config="$(readlink -f "$starship_config")"
fi

tmp_file="$(mktemp "${target_config}.noctalia.XXXXXX")"
cleanup() {
  rm -f "$tmp_file"
}
trap cleanup EXIT

if ! awk \
  -v begin="$begin_marker" \
  -v end="$end_marker" \
  -v palette="$palette_file" '
  BEGIN { state = 0; err = 0 }
  $0 == begin {
    if (state != 0) { err = 2; exit 2 }
    print
    while ((getline line < palette) > 0) {
      print line
    }
    close(palette)
    state = 1
    next
  }
  $0 == end {
    if (state != 1) { err = 3; exit 3 }
    print
    state = 2
    next
  }
  state != 1 { print }
  END {
    if (err != 0) exit err
    if (state != 2) exit 4
  }
' "$target_config" >"$tmp_file"; then
  printf 'utopia-starship: expected exactly one valid %s ... %s block in %s\n' \
    "$begin_marker" "$end_marker" "$target_config" >&2
  exit 1
fi

if cmp -s "$target_config" "$tmp_file"; then
  exit 0
fi

chmod --reference="$target_config" "$tmp_file"
mv "$tmp_file" "$target_config"
