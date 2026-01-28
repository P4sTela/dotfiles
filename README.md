# dotfiles

Nix Flakes + Home Manager + NixOS による宣言的な環境構築

## セットアップ

### NixOS on WSL

```bash
# dotfiles をクローン
ghq get github.com/P4sTela/dotfiles
cd ~/ghq/github.com/P4sTela/dotfiles

# NixOS 設定を適用
sudo nixos-rebuild switch --flake .#wsl
```

### macOS

```bash
# Nix のインストール (まだの場合)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# dotfiles をクローン
ghq get github.com/P4sTela/dotfiles
cd ~/ghq/github.com/P4sTela/dotfiles

# Home Manager 設定を適用
nix run home-manager -- switch --flake .#p4stela@mac
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
# 設定を適用
home-manager switch --flake .#p4stela@mac
```

### 共通

```bash
# 依存関係を更新
nix flake update

# 設定の検証
nix flake check
```

## 構成

```
.
├── flake.nix           # ルート flake (NixOS + Home Manager)
├── home/
│   ├── common.nix      # 共通 Home Manager 設定
│   ├── darwin.nix      # macOS 固有設定
│   └── nixos.nix       # NixOS 用 Home Manager 設定
├── nixos/
│   ├── common.nix      # 共通 NixOS 設定
│   └── wsl/
│       └── configuration.nix  # WSL 固有設定
└── envs/
    └── mogok/          # プロジェクト固有の開発環境例
        └── flake.nix
```

## プロジェクト用 devShell の作り方

### 1. プロジェクトに flake.nix を作成

```nix
{
  description = "Project dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # 複数システム対応
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ];
    in
    {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_22
              pnpm
              # 必要なパッケージを追加
            ];
          };
        });
    };
}
```

### 2. direnv で自動有効化

```bash
echo 'use flake' > .envrc
direnv allow
```

これで、ディレクトリに入ると自動的に開発環境が有効になります。

### よく使うパッケージ例

```nix
# Node.js
nodejs_22 pnpm bun

# Python
python313 uv

# Rust (バージョン固定する場合は rust-overlay を使用)
cargo rustc

# Go
go

# その他
jq yq-go awscli2
```
