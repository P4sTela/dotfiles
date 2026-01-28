# NixOS 統合計画

## 目的

NixOS の設定をこの dotfiles リポジトリで管理し、Home Manager 設定を再利用する。

## 現状

- Home Manager で WSL と macOS のユーザー環境を管理
- `home/common.nix` で共通設定を定義
- NixOS システム設定は管理していない

## 推奨アプローチ

### 最終的なディレクトリ構成

```
.
├── flake.nix                   # ルート flake
├── home/
│   ├── common.nix              # 共通 Home Manager 設定
│   ├── darwin.nix              # macOS 固有
│   ├── linux.nix               # Linux (WSL) 固有
│   └── nixos.nix               # NixOS 用（オプション）
├── nixos/
│   ├── common.nix              # 共通 NixOS 設定
│   └── <hostname>/
│       ├── configuration.nix   # ホスト固有設定
│       └── hardware-configuration.nix
└── modules/                    # カスタムモジュール（オプション）
    ├── home/
    └── nixos/
```

### flake.nix の拡張

```nix
{
  description = "p4stela's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # 既存の Home Manager 設定（standalone）
    homeConfigurations = {
      "p4stela@wsl" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home/linux.nix ];
      };

      "p4stela@mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home/darwin.nix ];
      };
    };

    # NixOS システム設定
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.p4stela = import ./home/common.nix;
          }
        ];
      };
    };
  };
}
```

## コマンド

### NixOS

```bash
# 設定を適用
sudo nixos-rebuild switch --flake .#desktop

# テスト（再起動なし）
sudo nixos-rebuild test --flake .#desktop

# boot エントリのみ作成
sudo nixos-rebuild boot --flake .#desktop
```

### Home Manager（standalone、既存と同じ）

```bash
home-manager switch --flake .#p4stela@wsl
home-manager switch --flake .#p4stela@mac
```

## Home Manager の再利用戦略

| 環境 | Home Manager 適用方法 |
|------|----------------------|
| WSL/macOS | standalone: `home-manager switch` |
| NixOS | NixOS モジュールとして統合: `nixos-rebuild switch` |

**共有する設定 (`home/common.nix`):**
- パッケージ (gh, ghq, fzf, ripgrep, etc.)
- プログラム設定 (fish, git, ssh, direnv)

**分離すべき設定:**
- NixOS 固有: ブートローダー、カーネル、ハードウェア、システムサービス
- macOS 固有: Homebrew、1Password SSH 連携
- WSL 固有: Windows 相互運用

## 実装ステップ

### Phase 1: 基本構成

1. [ ] `nixos/` ディレクトリ作成
2. [ ] `nixos/common.nix` 作成（共通 NixOS 設定）
3. [ ] `nixos/<hostname>/configuration.nix` 作成
4. [ ] `nixos/<hostname>/hardware-configuration.nix` をコピー
5. [ ] `flake.nix` に `nixosConfigurations` 追加
6. [ ] README.md 更新

### Phase 2: Home Manager 統合

1. [ ] `home/nixos.nix` を作成（NixOS 固有の Home Manager 設定）
2. [ ] NixOS モジュールとして Home Manager 統合をテスト

### Phase 3: 追加ホスト

1. [ ] サーバー設定を追加（必要に応じて）
2. [ ] Raspberry Pi など別アーキテクチャ対応（必要に応じて）

## 考慮事項

### nixpkgs バージョン

現在 `nixpkgs-unstable` を使用。NixOS でも同じバージョンを使うと一貫性が保てる。
ただし、NixOS では安定版（例: `nixos-24.11`）を使う選択肢もある。

### ハードウェア設定

`hardware-configuration.nix` は各マシンで生成:

```bash
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

このファイルはリポジトリに含めるべき。

### シークレット管理

既存の 1Password CLI + テンプレート方式は NixOS でも使用可能。
sops-nix も NixOS では良い選択肢。

## 参考リンク

- [NixOS Flakes](https://wiki.nixos.org/wiki/Flakes)
- [Home Manager - NixOS module](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module)
- [nixos-hardware](https://github.com/NixOS/nixos-hardware) - ハードウェア固有の設定
