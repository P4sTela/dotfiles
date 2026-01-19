{ pkgs, ... }:

{
  home.username = "p4stela";
  home.homeDirectory = "/home/p4stela";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    ghq
    fzf
    ripgrep
    eza
    bat
    wezterm
    nodejs
    neovim
    uv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting

      # Load secrets from local file (not tracked in git)
      if test -f ~/.secrets
        source ~/.secrets
      end
    '';
    shellAliases = {
      ls = "eza";
      cat = "bat";
    };
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675571571f068c1a02571794f";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "p4stela";
        email = "git@p4stela.net";
      };
      init.defaultBranch = "main";
    };
  };
  
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };
    };
  };


  programs.home-manager.enable = true;
}
