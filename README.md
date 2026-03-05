# tech-blog-writing

A Claude Code plugin that writes tech blog articles grounded in real project history. It researches GitHub issues, codebase git history, and Notion meeting notes, then synthesizes findings into a well-structured Japanese tech blog article.

## Prerequisites

### Required: GitHub CLI

```bash
brew install gh
gh auth login
```

The plugin uses `gh` to search issues, PRs, and comments as primary research sources. It will fail fast with a clear error if `gh` is not configured.

### Optional: Notion MCP

For richer articles that include meeting notes, specs, and internal documentation, configure the [Notion MCP server](https://github.com/makenotion/notion-mcp-server) in your Claude Code settings.

The plugin works without Notion but will skip that research stream and note it in the final summary.

## Installation

```bash
# Clone the repo
git clone https://github.com/deltaXinc/tech-blog-writing.git ~/Projects/tech-blog-writing

# Run the install script
cd ~/Projects/tech-blog-writing && ./install.sh
```

The install script:
1. Adds the plugin to `~/.claude/settings.json` (enabledPlugins)
2. Adds required tool permissions (gh, git, notion MCP) to the allow list
3. Validates that `gh` is installed and authenticated
4. Reports Notion MCP availability

After installation, restart Claude Code for the plugin to take effect.

## Usage

```
/tech-blog <topic description>
```

### Example

```
/tech-blog BatchWave: the evolution of our batch processing infrastructure
```

The plugin will:

1. **Validate** dependencies (gh CLI, Notion MCP)
2. **Ask** for target repository, date range, key search terms, and contributors
3. **Research** in parallel across GitHub, codebase, and Notion (if available)
4. **Present** a summary of findings and ask for your editorial direction
5. **Write** a full article draft in Japanese following the style guidelines
6. **Iterate** based on your feedback until you're satisfied

## Configuration

### Custom Style Guidelines

You can provide your own writing style guidelines file instead of the built-in default:

```
/tech-blog <topic>
```

When asked during setup, provide the path to your custom guidelines markdown file.

### Default Style

The built-in style (`guidelines/default-style.md`) produces articles suitable for Zenn, Qiita, or company tech blogs. It includes:

- Zenn-compatible frontmatter
- Japanese language with natural English technical terms
- Chronological or thematic structure
- 3,000-6,000 character target length

## How It Works

### Architecture

```
/tech-blog (orchestrator)
    |
    +-- [parallel] GitHub Agent    -> gh search issues/prs, gh api comments
    +-- [parallel] Codebase Agent  -> git log, git diff, git show, file reading
    +-- [parallel] Notion Agent    -> notion-search, notion-fetch (if available)
    |
    v
Research Reports (saved to /tmp/)
    |
    v
Article Draft (written to your specified location)
```

### Research Agents

| Agent | Sources | Tools Used |
|-------|---------|------------|
| GitHub | Issues, PRs, comments, discussions | `gh search`, `gh api` |
| Codebase | Git history, code files | `git log`, `git diff`, `git show`, Read, Glob, Grep |
| Notion | Meeting notes, specs, decisions | `notion-search`, `notion-fetch` |

Each agent returns a structured chronological report in Japanese. The orchestrator assembles these into the final article.

## Permissions

The install script adds these permissions to your Claude Code settings:

```json
{
  "permissions": {
    "allow": [
      "Bash(gh issue:*)",
      "Bash(gh pr:*)",
      "Bash(gh api:*)",
      "Bash(gh search:*)",
      "Bash(git log:*)",
      "Bash(git diff:*)",
      "Bash(git show:*)",
      "mcp__notion__notion-search",
      "mcp__notion__notion-fetch"
    ]
  }
}
```

## License

MIT
