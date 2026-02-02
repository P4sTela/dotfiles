{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    ghq
    lazygit
    fzf
    ripgrep
    eza
    bat
    btop
    nodejs
    neovim
    uv
    bun
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Nix の環境変数と PATH を設定
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Nix の補完パスを追加
      # fish 起動時に fish_complete_path が初期化された後で XDG_DATA_DIRS が設定されるため手動追加が必要
      for p in ~/.nix-profile/share/fish/vendor_completions.d /nix/var/nix/profiles/default/share/fish/vendor_completions.d
        if test -d $p; and not contains $p $fish_complete_path
          set -p fish_complete_path $p
        end
      end

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
