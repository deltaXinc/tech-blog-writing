# tech-blog-writing

A Claude Code plugin that writes tech blog articles grounded in real project history. It researches GitHub issues, codebase git history, and Notion meeting notes, then synthesizes findings into a well-structured Japanese tech blog article.

## Requirements

- [GitHub CLI](https://cli.github.com/) (`gh`) — used to search issues, PRs, and comments. The plugin checks for `gh` at startup and provides install instructions if missing.
- [Notion](https://www.notion.so/) integration token (optional) — set `NOTION_TOKEN` env var to enable Notion research. The plugin bundles the Notion MCP server automatically.

## Installation

```
/tech-blog-writing:tech-blog <topic description>
```

Or for local development/testing:

```bash
claude --plugin-dir /path/to/tech-blog-writing
```

### Notion Setup (optional)

To enable Notion research:

1. Go to https://www.notion.so/profile/integrations and create a new internal integration
2. In the integration's Configuration tab, copy the secret token (`ntn_****`)
3. In the Access tab, connect the pages/databases you want the plugin to search
4. Set the token as an environment variable before launching Claude Code:

```bash
export NOTION_TOKEN="ntn_****"
```

The plugin bundles the Notion MCP server via `.mcp.json` — no additional MCP configuration needed. If `NOTION_TOKEN` is not set, the plugin skips Notion research gracefully.

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

## Plugin Structure

```
tech-blog-writing/
├── .claude-plugin/
│   └── plugin.json                     # Plugin metadata
├── .mcp.json                           # Bundled Notion MCP server
├── agents/
│   ├── research-github.md              # GitHub issues/PRs researcher (subagent)
│   ├── research-codebase.md            # Git history & code researcher (subagent)
│   └── research-notion.md              # Notion pages researcher (subagent)
├── skills/
│   └── tech-blog/
│       ├── SKILL.md                    # Orchestrator (5-phase workflow)
│       └── guidelines/
│           └── default-style.md        # Default writing style
├── README.md
└── LICENSE
```

### Plugin Features Used

| Feature | Purpose |
|---------|---------|
| `skills/` | Main orchestrator skill (`/tech-blog-writing:tech-blog`) |
| `agents/` | 3 specialized research subagents with restricted tool access |
| `.mcp.json` | Bundled Notion MCP server — users just set `NOTION_TOKEN` |

### Research Subagents

| Subagent | Sources | Tools |
|----------|---------|-------|
| `research-github` | Issues, PRs, comments, discussions | Bash, Read, Grep |
| `research-codebase` | Git history, code files | Bash, Read, Glob, Grep |
| `research-notion` | Meeting notes, specs, decisions | notion-search, notion-fetch, Read |

Each subagent returns a structured chronological report in Japanese. The orchestrator assembles these into the final article.

## Configuration

### Custom Style Guidelines

When asked during setup, provide the path to your custom guidelines markdown file. The default style produces articles suitable for Zenn, Qiita, or company tech blogs:

- Zenn-compatible frontmatter
- Japanese language with natural English technical terms
- Chronological or thematic structure
- 3,000-6,000 character target length

## Permissions

Tool permissions (gh, git, Notion MCP) are declared in the skill's `allowed-tools` frontmatter — no global permission changes needed.

## License

MIT
