# NixOS on WSL 設定
{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # WSL 固有設定
  wsl = {
    enable = true;
    defaultUser = "p4stela";
    useWindowsDriver = true;
  };

  networking.hostName = "wsl";

  # NVIDIA/CUDA サポート (WSL)
  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
  };

  # Docker で GPU を使用するための設定
  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
  };

  # NixOS の状態バージョンを示す
  # home.stateVersion (Home Manager) とは異なる値になることがある
  system.stateVersion = "25.05";
}
