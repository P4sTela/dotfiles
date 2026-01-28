# NixOS on WSL 設定
{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
  ];

  # WSL 固有設定
  wsl = {
    enable = true;
    defaultUser = "p4stela";
    # Windows の PATH を引き継ぐ
    interop.includePath = true;
  };

  networking.hostName = "wsl";

  # NixOS の状態バージョン
  # Note: これは NixOS システムが最初にインストールされたバージョンを示す
  # home.stateVersion (Home Manager) とは異なる値になることがある
  system.stateVersion = "24.11";
}
