{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.username = "p4stela";
  home.homeDirectory = "/home/p4stela";

  home.packages = with pkgs; [
    # Linux-specific packages
    wezterm
  ];
}
