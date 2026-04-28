#!/usr/bin/env bash
# copilot/install.sh
# Installs adapted automotive agent .md files to the VS Code user prompts folder
# so they are available as agents in GitHub Copilot Chat.
#
# Usage:
#   ./copilot/install.sh              # install all agents
#   ./copilot/install.sh --dry-run    # preview without copying
#   ./copilot/install.sh --uninstall  # remove installed automotive agents

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
AGENTS_DIR="$REPO_ROOT/agents"

# Detect VS Code user prompts folder
if [[ "$OSTYPE" == "darwin"* ]]; then
  PROMPTS_DIR="$HOME/Library/Application Support/Code/User/prompts"
elif [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
  PROMPTS_DIR="$XDG_CONFIG_HOME/Code/User/prompts"
else
  PROMPTS_DIR="$HOME/.config/Code/User/prompts"
fi

DRY_RUN=false
UNINSTALL=false

for arg in "$@"; do
  case $arg in
    --dry-run)   DRY_RUN=true ;;
    --uninstall) UNINSTALL=true ;;
  esac
done

echo "Automotive Copilot Agent Installer"
echo "==================================="
echo "Agents source : $AGENTS_DIR"
echo "Prompts target: $PROMPTS_DIR"
echo ""

if $UNINSTALL; then
  count=0
  while IFS= read -r -d '' file; do
    base="$(basename "$file" .md)"
    target="$PROMPTS_DIR/automotive-$base.agent.md"
    if [[ -f "$target" ]]; then
      echo "  Remove: $target"
      $DRY_RUN || rm "$target"
      ((count++))
    fi
  done < <(find "$AGENTS_DIR" -name "*.md" -print0)
  echo ""
  echo "Removed $count automotive agent(s)."
  exit 0
fi

$DRY_RUN || mkdir -p "$PROMPTS_DIR"

count=0
while IFS= read -r -d '' file; do
  base="$(basename "$file" .md)"
  name="automotive-$base.agent.md"
  target="$PROMPTS_DIR/$name"
  if $DRY_RUN; then
    echo "  [dry-run] Would copy: $(basename "$file") -> $target"
  else
    cp "$file" "$target"
    echo "  Installed: $name"
  fi
  ((count++))
done < <(find "$AGENTS_DIR" -name "*.md" -print0)

echo ""
if $DRY_RUN; then
  echo "$count agent(s) would be installed."
else
  echo "$count agent(s) installed to $PROMPTS_DIR"
  echo "Restart VS Code or reload the window to pick up new agents."
fi
