#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "Installing tech-blog-writing plugin..."
echo ""

# --- Check gh CLI ---
if ! command -v gh &>/dev/null; then
  echo "ERROR: GitHub CLI (gh) is not installed."
  echo ""
  echo "  Install:  brew install gh"
  echo "  Login:    gh auth login"
  echo ""
  exit 1
fi

if ! gh auth status &>/dev/null 2>&1; then
  echo "ERROR: GitHub CLI is installed but not authenticated."
  echo ""
  echo "  Run:  gh auth login"
  echo ""
  exit 1
fi

echo "  gh CLI: OK"

# --- Check Notion MCP ---
# We can't check MCP availability from outside Claude Code, just inform the user
echo "  Notion MCP: Will be checked at runtime (optional)"

# --- Update settings.json ---
if [ ! -f "$SETTINGS_FILE" ]; then
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  echo '{}' > "$SETTINGS_FILE"
fi

# Use a temporary file for jq operations
TMP_SETTINGS=$(mktemp)

# Add plugin to enabledPlugins
jq --arg plugin "$PLUGIN_DIR" '
  .enabledPlugins = ((.enabledPlugins // []) | if index($plugin) then . else . + [$plugin] end)
' "$SETTINGS_FILE" > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" "$SETTINGS_FILE"

# Add permissions
PERMISSIONS=(
  'Bash(gh issue:*)'
  'Bash(gh pr:*)'
  'Bash(gh api:*)'
  'Bash(gh search:*)'
  'Bash(git log:*)'
  'Bash(git diff:*)'
  'Bash(git show:*)'
  'mcp__notion__notion-search'
  'mcp__notion__notion-fetch'
)

for perm in "${PERMISSIONS[@]}"; do
  TMP_SETTINGS=$(mktemp)
  jq --arg perm "$perm" '
    .permissions.allow = ((.permissions.allow // []) | if index($perm) then . else . + [$perm] end)
  ' "$SETTINGS_FILE" > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" "$SETTINGS_FILE"
done

echo ""
echo "Plugin installed successfully!"
echo ""
echo "  Plugin path: $PLUGIN_DIR"
echo "  Settings updated: $SETTINGS_FILE"
echo ""
echo "Restart Claude Code, then use:  /tech-blog <topic>"
echo ""
