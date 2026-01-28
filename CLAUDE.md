# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Nix Flakes + Home Manager + NixOS による宣言的な dotfiles リポジトリ。NixOS on WSL および macOS (Apple Silicon) 環境向け。

## Commands

### NixOS (WSL)

```bash
# 設定を適用
sudo nixos-rebuild switch --flake .#wsl

# テスト（再起動なし）
sudo nixos-rebuild test --flake .#wsl
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
- `flake.nix` - ルート flake。NixOS と Home Manager 設定を定義
  - `nixosConfigurations.wsl` - NixOS on WSL 用
  - `homeConfigurations."p4stela@mac"` - macOS (Apple Silicon) 用
- `nixos/common.nix` - 共通 NixOS 設定
- `nixos/wsl/configuration.nix` - WSL 固有の NixOS 設定
- `home/common.nix` - 共通 Home Manager 設定 (パッケージ、プログラム、シェル設定)
- `home/nixos.nix` - NixOS 用 Home Manager 設定
- `home/darwin.nix` - macOS 固有の設定 (Homebrew, 1Password SSH, OrbStack)
- `envs/<project>/flake.nix` - プロジェクト固有の開発環境 (参考用)

### 設定の追加方法
- 共通パッケージ追加: `home/common.nix` の `home.packages` に追加
- NixOS システム設定: `nixos/common.nix` または `nixos/wsl/configuration.nix` に追加
- macOS固有パッケージ: `home/darwin.nix` の `home.packages` に追加
- プログラム設定: `home/common.nix` の `programs.<name>` モジュールを使用

### シークレット
`~/.secrets` から読み込み (git 管理外)

## TODO

- [ ] `~/.config/ghostty/config` を dotfiles に統合
- [ ] `~/.config/zellij/` (config.kdl, layouts) を dotfiles に統合
- [ ] `~/.config/yazi/yazi.toml` を dotfiles に統合
- [ ] Secrets 管理を 1Password CLI + SOPS で実装 (詳細: `docs/plans/secrets-management.md`)
