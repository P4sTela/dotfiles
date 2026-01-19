# dotfiles

Nix Flakes + Home Manager による宣言的な環境構築

## セットアップ

```bash
# Nix のインストール (まだの場合)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# dotfiles をクローン
ghq get github.com/p4stela/dotfiles
cd ~/ghq/github.com/p4stela/dotfiles

# Home Manager 設定を適用
nix run home-manager -- switch --flake .
```

## コマンド

### Home Manager (メイン環境)

```bash
# 設定を適用
home-manager switch --flake .

# 依存関係を更新
nix flake update

# 設定を適用 (初回、home-manager コマンドがない場合)
nix run home-manager -- switch --flake .
```

### Mogok 開発環境

Rust + Node.js/Bun のプロジェクト用

```bash
# 開発シェルに入る
nix develop ./envs/mogok

# direnv 使用時 (プロジェクトディレクトリに .envrc を作成)
echo "use flake path/to/dotfiles/envs/mogok" > .envrc
direnv allow
```

## 構成

```
.
├── flake.nix           # ルート flake (Home Manager)
├── home/
│   └── linux.nix       # パッケージ・プログラム設定
└── envs/
    └── mogok/          # Rust プロジェクト用開発環境
        └── flake.nix
```

## インストールされるツール

- ghq, fzf, ripgrep, eza, bat - CLI ツール
- neovim - エディタ
- nodejs, uv - ランタイム・パッケージマネージャ
- wezterm - ターミナル
- fish - シェル (direnv, z プラグイン付き)
