# NixOS on WSL 設定
{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
    <nixos-wsl/modules>
  ];

  # WSL 固有設定
  wsl = {
    enable = true;
    defaultUser = "p4stela";
  };

  networking.hostName = "wsl";

  # NixOS の状態バージョン
  # Note: これは NixOS システムが最初にインストールされたバージョンを示す
  # home.stateVersion (Home Manager) とは異なる値になることがある
  system.stateVersion = "25.05";
}
