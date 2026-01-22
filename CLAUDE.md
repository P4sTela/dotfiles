# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Nix Flakes + Home Manager による宣言的な dotfiles リポジトリ。WSL2 および macOS (Apple Silicon) 環境向け。

## Commands

### Home Manager (WSL)

```bash
# 設定を適用
home-manager switch --flake .#p4stela@wsl

# 初回適用 (home-manager コマンドがない場合)
nix run home-manager -- switch --flake .#p4stela@wsl
```

### Home Manager (macOS)

```bash
# 設定を適用
home-manager switch --flake .#p4stela@mac

# 初回適用 (home-manager コマンドがない場合)
nix run home-manager -- switch --flake .#p4stela@mac
```

### 共通

```bash
# 依存関係を更新
nix flake update

# 設定の検証
nix flake check
```

### devShell (プロジェクト開発環境)

詳細は README.md の「プロジェクト用 devShell の作り方」を参照。

```bash
# プロジェクトに flake.nix を作成後
echo 'use flake' > .envrc
direnv allow
```

## Architecture

### Flake 構成
- `flake.nix` - ルート flake。Home Manager 設定を定義
  - `p4stela@wsl` - WSL (Linux x86_64) 用
  - `p4stela@mac` - macOS (Apple Silicon) 用
- `home/common.nix` - 共通設定 (パッケージ、プログラム、シェル設定)
- `home/linux.nix` - Linux (WSL) 固有の設定
- `home/darwin.nix` - macOS 固有の設定 (Homebrew, 1Password SSH, OrbStack)
- `envs/<project>/flake.nix` - プロジェクト固有の開発環境 (参考用)

### 設定の追加方法
- 共通パッケージ追加: `home/common.nix` の `home.packages` に追加
- Linux固有パッケージ: `home/linux.nix` の `home.packages` に追加
- macOS固有パッケージ: `home/darwin.nix` の `home.packages` に追加
- プログラム設定: `home/common.nix` の `programs.<name>` モジュールを使用

### シークレット
`~/.secrets` から読み込み (git 管理外)

## TODO

- [ ] `~/.config/ghostty/config` を dotfiles に統合
- [ ] `~/.config/zellij/` (config.kdl, layouts) を dotfiles に統合
- [ ] `~/.config/yazi/yazi.toml` を dotfiles に統合
- [ ] Secrets 管理を 1Password CLI + SOPS で実装 (詳細: `docs/plans/secrets-management.md`)
