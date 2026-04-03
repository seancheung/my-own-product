#!/usr/bin/env bash
set -euo pipefail

REPO="seancheung/my-own-product"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/commands"

COMMANDS=(
  mop-start.md
  mop-import.md
  mop-req.md
  mop-prod.md
  mop-ui.md
  mop-tech.md
  mop-tasks.md
  mop-dev.md
  mop-qa.md
  mop-sync.md
)

usage() {
  cat <<EOF
MOP Installer — My Own Product

Usage:
  install.sh [OPTIONS]

Options:
  -g, --global    Install to ~/.claude/commands/ (all projects)
  -l, --local     Install to .claude/commands/ in current directory (default)
  -h, --help      Show this help message

Examples:
  # Install to current project (default)
  curl -fsSL https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh | bash

  # Install globally
  curl -fsSL https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh | bash -s -- --global
EOF
}

main() {
  local mode="local"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -g|--global) mode="global"; shift ;;
      -l|--local)  mode="local";  shift ;;
      -h|--help)   usage; exit 0 ;;
      *) echo "Unknown option: $1"; usage; exit 1 ;;
    esac
  done

  if [[ "$mode" == "global" ]]; then
    target_dir="$HOME/.claude/commands"
  else
    target_dir=".claude/commands"
  fi

  echo "Installing MOP commands to ${target_dir} ..."
  mkdir -p "$target_dir"

  local failed=0
  for cmd in "${COMMANDS[@]}"; do
    if curl -fsSL "${BASE_URL}/${cmd}" -o "${target_dir}/${cmd}"; then
      echo "  ✓ ${cmd}"
    else
      echo "  ✗ ${cmd} (download failed)"
      failed=1
    fi
  done

  if [[ "$failed" -eq 1 ]]; then
    echo ""
    echo "Some files failed to download. Please check your network and try again."
    exit 1
  fi

  echo ""
  echo "Done! Installed ${#COMMANDS[@]} commands."
  echo ""
  echo "Open Claude Code and type /mop-start to get started."
}

main "$@"
