# Tech Blog Writing Guidelines

This is the default writing style guide for the tech-blog-writing plugin. It produces articles suitable for publication on Zenn, Qiita, or company tech blogs.

## Language

- Write the article body entirely in Japanese
- Technical terms may remain in English where natural (e.g., "GitHub Actions", "Docker", "CI/CD")
- Code comments may be in English or Japanese, matching the project's convention

## Structure

### Title
- Clear and specific (e.g., "BatchWaveの設計と進化 — 大規模バッチ処理基盤の3年間")
- Avoid vague titles; the reader should know what they'll learn

### Header Image / Emoji
- Suggest an appropriate emoji for Zenn-style articles

### Introduction (はじめに)
- 1-2 paragraphs setting up the context
- What problem does this technology/system solve?
- Why is this article worth reading?

### Background (背景)
- What existed before? What was the pain point?
- Include specific numbers or examples where available

### Main Body
- Organize chronologically OR by theme, depending on what fits the topic
- Use H2 (`##`) for major sections, H3 (`###`) for subsections
- Include code snippets, architecture diagrams (as mermaid or text), and configuration examples where relevant
- Reference specific GitHub issues/PRs with links when discussing decisions
- Use blockquotes (`>`) for notable quotes from discussions or meeting notes

### Lessons Learned (学び・振り返り)
- What worked well?
- What would you do differently?
- Concrete takeaways the reader can apply

### Conclusion (おわりに)
- Brief summary of the journey
- Future outlook if applicable
- Call to action or invitation for discussion

## Tone

- Professional but approachable
- First person plural ("私たちは") when describing team decisions
- Honest about challenges and failures, not just successes
- Show the messy reality of engineering, not just the clean result

## Formatting

- Keep paragraphs short (3-5 sentences max)
- Use bullet points for lists of items
- Use numbered lists for sequential steps
- Include code blocks with language tags (```typescript, ```yaml, etc.)
- Use tables for comparisons
- Add line breaks between sections for readability

## Length

- Target: 3,000-6,000 Japanese characters (roughly 5-10 minute read)
- Longer is acceptable for complex topics, but prefer splitting into a series

## Attribution

- Credit team members by name (or handle) when discussing their contributions
- Link to relevant GitHub issues/PRs for readers who want to dig deeper
- Mention tools and libraries used with their versions where relevant

## Article Metadata (Zenn format)

```yaml
---
title: "<article title>"
emoji: "<suggested emoji>"
type: "tech"
topics: ["<topic1>", "<topic2>", "<topic3>"]
published: false
---
```
