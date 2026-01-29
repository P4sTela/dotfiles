# NixOS 用 Home Manager 設定
{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.username = "p4stela";
  home.homeDirectory = "/home/p4stela";

  home.packages = with pkgs; [
    # NixOS-specific packages (if any)
    wezterm
  ];

  programs.fish.interactiveShellInit = ''
    fish_add_path "$HOME/.local/bin"
  '';
}
