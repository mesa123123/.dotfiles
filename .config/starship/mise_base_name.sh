#!/usr/bin/env bash

# Find .mise.toml in the current/parent directories
find_mise_toml() {
  local dir=$(pwd)
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.mise.toml" ]]; then
      echo "$dir/.mise.toml"
      return
    fi
    dir=$(dirname "$dir")
  done
}

# Extract BASE_NAME if .mise.toml exists
config_file=$(find_mise_toml)
if [[ -n "$config_file" ]]; then
  grep -E '^BASE_NAME\s*=\s*".*"' "$config_file" | \
  sed -E 's/^BASE_NAME\s*=\s*"([^"]*)".*$/\1/'
fi
