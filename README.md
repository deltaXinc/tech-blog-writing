# tech-blog-writing

A Claude Code plugin that writes tech blog articles grounded in real project history. It researches GitHub issues, codebase git history, and Notion meeting notes, then synthesizes findings into a well-structured Japanese tech blog article.

## Requirements

- [GitHub CLI](https://cli.github.com/) (`gh`) — used to search issues, PRs, and comments
- [Notion MCP server](https://github.com/makenotion/notion-mcp-server) (optional) — for meeting notes, specs, and internal docs

## Installation

```bash
# Clone the repo
git clone https://github.com/deltaXinc/tech-blog-writing.git ~/Projects/tech-blog-writing

# Run the install script
cd ~/Projects/tech-blog-writing && ./install.sh
```

The install script:
1. Installs and authenticates `gh` if not already set up
2. Adds the plugin to `~/.claude/settings.json` (enabledPlugins)
3. Adds required tool permissions (gh, git, Notion MCP) to the allow list

After installation, restart Claude Code for the plugin to take effect.

## Usage

```
/tech-blog-writing:tech-blog <topic description>
```

### Example

```
/tech-blog-writing:tech-blog BatchWave: the evolution of our batch processing infrastructure
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

When asked during setup, provide the path to your custom guidelines markdown file. The default style (`guidelines/default-style.md`) produces articles suitable for Zenn, Qiita, or company tech blogs:

- Zenn-compatible frontmatter
- Japanese language with natural English technical terms
- Chronological or thematic structure
- 3,000-6,000 character target length

## How It Works

```
/tech-blog-writing:tech-blog (orchestrator)
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

### Plugin Structure

```
tech-blog-writing/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── tech-blog/
│       ├── SKILL.md                   # Orchestrator (5-phase workflow)
│       ├── agents/
│       │   ├── research-github.md     # GitHub issues/PRs researcher
│       │   ├── research-codebase.md   # Git history & code researcher
│       │   └── research-notion.md     # Notion pages researcher
│       └── guidelines/
│           └── default-style.md       # Default writing style
├── install.sh
├── README.md
└── LICENSE
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
