# tech-blog-writing

プロジェクトの実際の履歴（GitHub Issue/PR、gitコミット履歴、Notion議事録）をリサーチし、日本語のテックブログ記事を生成するClaude Codeプラグインです。

## 前提条件

- [GitHub CLI](https://cli.github.com/) (`gh`) — Issue、PR、コメントの検索に使用
- [Notion](https://www.notion.so/) インテグレーショントークン（任意） — Notionリサーチを有効にする場合に必要

## インストール

```
/plugin marketplace add deltaXinc/tech-blog-writing
/plugin install tech-blog-writing@deltaXinc-plugins
```

### Notionセットアップ（任意）

1. https://www.notion.so/profile/integrations で内部インテグレーションを作成
2. Configurationタブからシークレットトークン（`ntn_****`）をコピー
3. Accessタブで検索対象のページ/データベースを接続
4. 環境変数を設定してClaude Codeを起動:

```bash
export NOTION_TOKEN="ntn_****"
```

プラグインがNotion MCPサーバーを自動で起動するため、追加のMCP設定は不要です。

## 使い方

```
/tech-blog-writing:tech-blog <トピック>
```

### 例

```
/tech-blog-writing:tech-blog FormHub: 問い合わせフォームを「データ」で定義するプラットフォームの設計と運用
```

プラグインの実行フロー:

1. **依存チェック** — gh CLI、Notion MCPの確認
2. **パラメータ収集** — 対象リポジトリ、検索キーワード、期間などをヒアリング
3. **並列リサーチ** — GitHub、コードベース、Notionの3ソースを同時調査
4. **調査結果の共有** — 発見事項を要約し、記事の方向性をヒアリング
5. **記事執筆** — スタイルガイドラインに沿って日本語のドラフトを生成
6. **フィードバック反映** — ユーザーの指摘に基づいて修正を繰り返す

## カスタムスタイルガイド

セットアップ時にカスタムガイドラインのパスを指定できます。デフォルトのスタイルはZenn/Qiita/社内ブログ向けです:

- Zenn互換のフロントマター
- 日本語本文（技術用語は英語のまま）
- 3,000〜6,000文字の目安

## ライセンス

MIT
