# Automotive Claude Code Agents — GitHub Copilot Adaptation

This branch (`copilot-adaptations`) adapts the original Claude Code agent library for use with **GitHub Copilot** in VS Code.

## What Changed

| Artifact | Original (Claude Code) | Adapted (Copilot) |
|---|---|---|
| Agent `.md` files | No frontmatter | YAML frontmatter with `description` + `tools` |
| Install target | `~/.claude/` | VS Code user prompts folder |
| Slash commands | `/automotive <cmd>` | Copilot chat `@agent` or prompt files |
| YAML agent files | Native Claude format | Not supported — use `.md` equivalents |
| Hooks | Git pre-commit shell scripts | Unchanged — still usable independently |
| Skills / knowledge-base | Loaded by Claude automatically | Reference manually or via `#file:` in chat |

## Install for GitHub Copilot

### Windows (PowerShell)

```powershell
.\copilot\install.ps1
```

### macOS / Linux (bash)

```bash
./copilot/install.sh
```

Both scripts copy the adapted agent `.md` files to your VS Code user prompts folder so they appear as selectable agents in Copilot Chat.

### Manual install

Copy the `.md` files from `agents/**/*.md` into:
- **Windows**: `%APPDATA%\Code\User\prompts\`
- **macOS/Linux**: `~/.config/Code/User/prompts/`

## Using the Agents in Copilot Chat

Once installed, open Copilot Chat (`Ctrl+Alt+I`) and select an agent from the dropdown, or reference one directly:

```
@adas-perception-engineer Design a LiDAR point cloud pipeline for obstacle detection
@safety-engineer Generate an HARA template for an ASIL-D braking system
@autosar-adaptive-developer Scaffold an ara::com service for camera data
```

## Referencing Skills and Knowledge Base

Copilot does not auto-load skills. Reference them explicitly with `#file:`:

```
#file:external/automotive-claude-code-agents/skills/automotive-safety/iso-26262-overview.md
Explain ASIL decomposition for this component
```

## Keeping Up with Upstream

The upstream remote points to the original repository:

```bash
git fetch upstream
git checkout main
git merge upstream/main
git checkout copilot-adaptations
git rebase main
git push origin copilot-adaptations --force-with-lease
```

## Branch Strategy

```
main                   ← tracks upstream (im-hashim/automotive-claude-code-agents)
copilot-adaptations    ← all Copilot-specific changes live here
```

Never commit Copilot adaptations to `main`. Keep `main` a clean mirror of upstream so merges stay conflict-free.
