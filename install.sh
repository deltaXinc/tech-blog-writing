#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "Installing tech-blog-writing plugin..."
echo ""

# --- Setup gh CLI ---
if ! command -v gh &>/dev/null; then
  echo "  gh CLI: Not found. Installing..."
  if command -v brew &>/dev/null; then
    brew install gh
  else
    echo "ERROR: Homebrew is not installed. Install gh manually: https://cli.github.com/"
    exit 1
  fi
fi

if ! gh auth status &>/dev/null 2>&1; then
  echo "  gh CLI: Not authenticated. Running gh auth login..."
  gh auth login
fi

echo "  gh CLI: OK"

# --- Notion MCP ---
if [ -n "${NOTION_TOKEN:-}" ]; then
  echo "  Notion: NOTION_TOKEN is set — Notion MCP will be available"
else
  echo "  Notion: NOTION_TOKEN not set — set it to enable Notion research (optional)"
fi

# --- Update settings.json ---
if [ ! -f "$SETTINGS_FILE" ]; then
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  echo '{}' > "$SETTINGS_FILE"
fi

TMP_SETTINGS=$(mktemp)

# Add plugin to enabledPlugins (object format: {"path": true})
jq --arg plugin "$PLUGIN_DIR" '
  .enabledPlugins = ((.enabledPlugins // {}) | .[$plugin] = true)
' "$SETTINGS_FILE" > "$TMP_SETTINGS" && mv "$TMP_SETTINGS" "$SETTINGS_FILE"

# Note: Tool permissions (gh, git, notion) are handled by the skill's
# allowed-tools frontmatter — no need to modify global permissions.

echo ""
echo "Plugin installed successfully!"
echo ""
echo "  Plugin path: $PLUGIN_DIR"
echo "  Settings updated: $SETTINGS_FILE"
echo ""
echo "Restart Claude Code, then use:  /tech-blog-writing:tech-blog <topic>"
echo ""
