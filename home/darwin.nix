{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.username = "p4stela";
  home.homeDirectory = "/Users/p4stela";

  home.packages = with pkgs; [
    # Mac-specific packages
    wezterm
  ];

  # macOS-specific fish configuration
  programs.fish.interactiveShellInit = ''
    # Homebrew
    eval (/opt/homebrew/bin/brew shellenv)
    if test -d /opt/homebrew/share/fish/vendor_completions.d
      contains /opt/homebrew/share/fish/vendor_completions.d $fish_complete_path
      or set -p fish_complete_path /opt/homebrew/share/fish/vendor_completions.d
    end

    # OrbStack
    source ~/.orbstack/shell/init2.fish 2>/dev/null || :

    # LM Studio CLI
    set -gx PATH $PATH /Users/p4stela/.lmstudio/bin
  '';

  # 1Password SSH signing (macOS)
  programs.git.settings."gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  # macOS-specific SSH configuration
  programs.ssh = {
    includes = [ "~/.orbstack/ssh/config" ];
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        extraOptions = {
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
      };
      "desktop" = {
        hostname = "100.75.46.78";
        user = "p4stela";
      };
      "sato-containerlab" = {
        hostname = "sato-containerlab";
        user = "root";
      };
    };
  };
}
