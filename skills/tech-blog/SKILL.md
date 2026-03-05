---
name: tech-blog
description: Write tech blog articles grounded in real project history by researching GitHub issues, codebase git history, and Notion meeting notes.
argument-hint: "[topic description]"
disable-model-invocation: true
allowed-tools: Bash(gh *), Bash(git log *), Bash(git diff *), Bash(git show *), Bash(gh auth status), Read, Write, Glob, Grep, Agent, mcp__notion__notion-search, mcp__notion__notion-fetch
---

# Tech Blog Article Writer

You are a tech blog article writing orchestrator. You research real project history across GitHub, codebase, and Notion, then synthesize findings into a well-structured Japanese tech blog article.

## Phase 1: Setup & Validation

### Step 1: Check gh CLI (REQUIRED)

Run `gh auth status` to verify the GitHub CLI is installed and authenticated.

If it fails, output the following and STOP immediately:

```
GitHub CLI (gh) is required but not configured.

Install:  brew install gh
Login:    gh auth login

The tech-blog plugin uses GitHub issues, PRs, and comments as primary research sources.
Re-run /tech-blog-writing:tech-blog after setup.
```

### Step 2: Check Notion MCP (OPTIONAL)

Check if the `mcp__notion__notion-search` tool is available. Set an internal flag for whether Notion research is possible.

If NOT available, output:

```
Notion MCP is not configured. Proceeding without Notion research.

To enable Notion research, set the NOTION_TOKEN environment variable and restart Claude Code.
The plugin bundles the Notion MCP server automatically.
```

### Step 3: Gather Parameters

Parse the user's topic from `$ARGUMENTS`.

Then ask the user interactively for the following:
- **Target repository** (org/repo format, e.g. `deltaXinc/bestjuku.com`)
- **Date range** (optional, default: all time)
- **Key search terms, people, or branches** relevant to the topic
- **Custom style guidelines file** (optional, default: built-in)

Wait for the user's answers before proceeding to Phase 2.

## Phase 2: Parallel Research

Launch 2-3 research subagents in parallel. Each subagent returns structured findings as text (NOT files). Pass the gathered parameters (repo, date range, search terms, topic) to each subagent.

### Subagent 1: GitHub Research

Delegate to the `tech-blog-writing:research-github` subagent. Pass:
- Repository (org/repo)
- Topic description
- Key search terms and people
- Date range

### Subagent 2: Codebase Research

Delegate to the `tech-blog-writing:research-codebase` subagent. Pass:
- Topic description
- Key search terms, branches, file paths
- Date range

### Subagent 3: Notion Research (only if Notion MCP is available)

Delegate to the `tech-blog-writing:research-notion` subagent. Pass:
- Topic description
- Key search terms (both Japanese and English)
- Date range

**IMPORTANT**: Launch all applicable subagents simultaneously for maximum efficiency.

## Phase 3: Report Assembly

After all subagents complete:

1. Save each research report to temporary files:
   - `/tmp/tech-blog-research-github.md`
   - `/tmp/tech-blog-research-codebase.md`
   - `/tmp/tech-blog-research-notion.md` (if applicable)

2. Present a summary to the user:
   - Key themes discovered across sources
   - Date range covered
   - Number of issues/PRs, commits, and Notion pages found
   - Notable findings or surprises

3. Ask the user for direction:
   - What angle should the article take?
   - What should be emphasized or de-emphasized?
   - What should be included or excluded?
   - Any specific structure preferences?

Wait for the user's input before proceeding.

## Phase 4: Article Writing

1. Read the writing guidelines file. Default: read `${CLAUDE_SKILL_DIR}/guidelines/default-style.md`. If the user specified a custom file, read that instead.

2. Read all research reports from `/tmp/tech-blog-research-*.md`.

3. Write the full article draft in Japanese following:
   - The writing guidelines
   - The user's direction from Phase 3
   - The research findings

4. Save the draft to the location the user specifies. Default: `./tech-blog-draft.md` in the current working directory.

## Phase 5: Iteration & Summary

Present the draft to the user and ask for feedback. Revise based on their input. Repeat as needed.

When the user is satisfied, output the final research source summary:

```
Research Sources:
  GitHub Issues/PRs — [count] related issues/PRs analyzed
  Codebase — [count] commits analyzed from git history
  Notion — [Used: [count] pages referenced / Not used: Notion MCP not configured]
```
