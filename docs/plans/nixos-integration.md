# NixOS 統合計画

## 目的

NixOS の設定をこの dotfiles リポジトリで管理し、Home Manager 設定を再利用する。

## ステータス

**実装完了** ✅

## 現在の構成

```
.
├── flake.nix                   # ルート flake (NixOS + Home Manager)
├── home/
│   ├── common.nix              # 共通 Home Manager 設定
│   ├── darwin.nix              # macOS 固有
│   └── nixos.nix               # NixOS 用 Home Manager 設定
├── nixos/
│   ├── common.nix              # 共通 NixOS 設定
│   └── wsl/
│       └── configuration.nix   # WSL 固有設定
└── envs/
    └── mogok/                  # プロジェクト固有の開発環境例
```

## コマンド

### NixOS (WSL)

```bash
# 設定を適用
sudo nixos-rebuild switch --flake .#wsl

# テスト（再起動なし）
sudo nixos-rebuild test --flake .#wsl
```

### macOS

```bash
home-manager switch --flake .#p4stela@mac
```

## Home Manager の再利用戦略

| 環境 | Home Manager 適用方法 |
|------|----------------------|
| macOS | standalone: `home-manager switch` |
| NixOS on WSL | NixOS モジュールとして統合: `nixos-rebuild switch` |

**共有する設定 (`home/common.nix`):**
- パッケージ (gh, ghq, fzf, ripgrep, etc.)
- プログラム設定 (fish, git, ssh, direnv)

**分離すべき設定:**
- NixOS 固有: システムサービス、ユーザー管理
- macOS 固有: Homebrew、1Password SSH 連携
- WSL 固有: Windows 相互運用 (NixOS-WSL モジュール)

## 参考リンク

- [NixOS Flakes](https://wiki.nixos.org/wiki/Flakes)
- [Home Manager - NixOS module](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module)
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
