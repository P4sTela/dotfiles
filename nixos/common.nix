# 共通 NixOS 設定
{ config, pkgs, ... }:

{
  # Nix 設定
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # タイムゾーン
  time.timeZone = "Asia/Tokyo";

  # ロケール
  i18n.defaultLocale = "en_US.UTF-8";

  # 基本パッケージ
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  # ユーザー設定
  users.users.p4stela = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  # Fish を有効化
  programs.fish.enable = true;
}
