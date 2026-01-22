{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    ghq
    fzf
    ripgrep
    eza
    bat
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
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFS7QAGA/JK7Orgdp88AC9Fc4vInaLItBNASgPvDPLA";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "P4sTela";
        email = "p4stela.dev@gmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      gpg.format = "ssh";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };
    };
  };

  programs.home-manager.enable = true;
}
