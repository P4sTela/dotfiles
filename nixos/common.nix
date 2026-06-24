# 共通 NixOS 設定
{ pkgs, ... }:

{
  # Nix 設定
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # ストアの重複をハードリンクで自動最適化
    auto-optimise-store = true;
  };

  # 古い世代を定期的に自動 GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # タイムゾーン
  time.timeZone = "Asia/Tokyo";

  # ロケール
  i18n.defaultLocale = "en_US.UTF-8";

  # 基本パッケージ
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    htop
  ];

  # SSHサーバーの有効化
  services.openssh = {
    enable = true;

    # 追加のセキュリティ設定（推奨）
    settings = {
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # ユーザー設定
  users.users.p4stela = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXE3/lHZSI0rdmhrnAMo4qRSJYVNvDhzNdjp4djizH8"
    ];
  };

  users.users.root.shell = pkgs.fish;

  # Fish を有効化
  programs.fish.enable = true;

  programs.nix-ld.enable = true;

  # Docker
  virtualisation.docker.enable = true;
}
