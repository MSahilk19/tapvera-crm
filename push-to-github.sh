#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/MSahilk19/tapvera-crm.git"

if [[ ! -f package.json || ! -d packages ]]; then
  echo "Run this script from the extracted TapCRM project root (the folder containing package.json)." >&2
  exit 1
fi

if [[ -f .env ]]; then
  echo "Safety stop: .env exists. It will NOT be committed. Check .gitignore before continuing." >&2
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Git is required. Install Xcode Command Line Tools with: xcode-select --install" >&2
  exit 1
fi

git init -b main
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REPO_URL"
else
  git remote add origin "$REPO_URL"
fi

git add -A
if git diff --cached --quiet; then
  echo "No new changes to commit."
else
  git commit -m "Import existing TapCRM source code"
fi

echo
echo "Pushing TapCRM to $REPO_URL ..."
git push -u origin main

echo
echo "Done. Repository: https://github.com/MSahilk19/tapvera-crm"
