# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Nix Flakes + Home Manager による宣言的な dotfiles リポジトリ。主に WSL2 環境向け。

## Commands

### Home Manager (メイン環境)

```bash
# 設定を適用
home-manager switch --flake .

# 依存関係を更新
nix flake update

# 初回適用 (home-manager コマンドがない場合)
nix run home-manager -- switch --flake .
```

### Mogok 開発環境 (Rust + Node.js/Bun)

```bash
# 開発シェルに入る
nix develop ./envs/mogok

# direnv 使用時
echo "use flake path/to/dotfiles/envs/mogok" > .envrc
direnv allow
```

## Architecture

### Flake 構成
- `flake.nix` - ルート flake。`p4stela@wsl` の Home Manager 設定を定義
- `home/linux.nix` - パッケージ、プログラム、シェル設定
- `envs/<project>/flake.nix` - プロジェクト固有の開発環境

### 設定の追加方法
- パッケージ追加: `home/linux.nix` の `home.packages` に追加
- プログラム設定: `programs.<name>` モジュールを使用
- 新しい開発環境: `envs/` 配下に `flake.nix` を作成 (`envs/mogok/flake.nix` を参考に)

### シークレット
`~/.secrets` から読み込み (git 管理外)
