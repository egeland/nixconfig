#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#
{pkgs, ...}: {
  # imports =
  #   [
  #     ../modules/programs/alacritty.nix
  #   ];

  home = {
    # Specific packages for macbook
    packages = with pkgs; [
      bat
      delta
      fish
      fzf
      gnupg
      hugo
      kitty
      lsd
      pfetch
      pinentry_mac
      python310
      python310Packages.ipython
      python310Packages.pip
      pwgen
      rectangle
      starship
      yubikey-personalization
      zoxide
    ];
    stateVersion = "22.11";
  };

  # Raw config files
  home.file.".gnupg/gpg-agent.conf" = {
    source = ./gpg-agent.conf;
    onChange = ''echo "gpg-agent change detected"; ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent'';
  };
  home.file.".gnupg/sshcontrol" = {
    text = "032896FEEFADEBAF209C345A90DE6FDDD9BB2A1B";
    onChange = "${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent";
  };
  home.file.".config/karabiner/karabiner.json" = {
    source = ../common/karabiner.json;
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode;
      enableExtensionUpdateCheck = true;
      extensions = with pkgs; [
        vscode-extensions.bbenoist.nix
        vscode-extensions.kamadorueda.alejandra
        vscode-extensions.ms-python.python
        vscode-extensions.mhutchie.git-graph
        vscode-extensions.timonwong.shellcheck
        vscode-extensions.oderwat.indent-rainbow
        vscode-extensions.donjayamanne.githistory
        vscode-extensions.yzhang.markdown-all-in-one
      ];
    };
    gpg = {
      enable = true;
      mutableKeys = true;
      settings = {
        no-greeting = true;
        auto-key-retrieve = true;
        default-key = "0x6249C5087F5382D2";
        trusted-key = "0x6249C5087F5382D2";
        keyserver = "hkps://keyserver.ubuntu.com";
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
    git = {
      enable = true;
      package = pkgs.git;
      userName = "Frode Egeland";
      userEmail = "egeland@gmail.com";
      signing = {
        key = "0x6249C5087F5382D2";
        signByDefault = true;
      };
      delta.enable = true;
      aliases = {
        ci = "commit --signoff";
        prp = "pull --rebase --prune";
        lg = "log --oneline --abbrev-commit --all --graph --decorate --color --show-signature --no-merges";
        cb = "checkout -b";
        co = "checkout";
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
      };
    };
    zsh = {
      # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true; # Auto suggest options and highlights syntax. It searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {
        # Extra plugins for zsh
        enable = true;
        plugins = [
          "fd"
          "fzf"
          "git"
          "ripgrep"
          "zoxide"
        ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      shellAliases = {
        c = "z";
        ci = "zi";
        ls = "lsd";
        rb = "pushd ~/nixconfig; darwin-rebuild switch --verbose --flake .#$(hostname -s); popd";
      };

      initExtra = ''
        autoload -U promptinit; promptinit
        pfetch
      '';
    };
    starship = {
      enable = true;
      settings = {
        sudo = {
          disabled = false;
        };
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace # Opens document where you left it
        auto-pairs # Print double quotes/brackets/etc.
        vim-gitgutter # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree # File Manager - set in extraConfig to F6

        # Customization
        wombat256-vim # Color scheme for lightline
        srcery-vim # Color scheme for text

        lightline-vim # Info bar at bottom
        indent-blankline-nvim # Indentation lines
      ];

      extraConfig = ''
        syntax enable                             " Syntax highlighting
        colorscheme srcery                        " Color scheme text

        let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }                                     " Color scheme lightline

        highlight Comment cterm=italic gui=italic " Comments become italic
        hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

        set number                                " Set numbers

        nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
      '';
    };
  };
  services = {
  };
}
