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
{
  pkgs,
  sshcontrol_value,
  ...
}: {
  # imports =
  #   [
  #     ../modules/programs/alacritty.nix
  #   ];

  home = {
    # Specific packages for macbook
    packages = with pkgs; [
      pinentry_mac
      pfetch
      starship
      fish
      lsd
      bat
      kitty
      rectangle
      fzf
      zoxide
      yubikey-personalization
      gnupg
      python310
      python310Packages.pip
      python310Packages.ipython
    ];
    stateVersion = "22.05";
  };

  # Raw config files
  home.file.".gnupg/gpg-agent.conf" = {
    source = ./gpg-agent.conf;
    onChange = ''echo "gpg-agent change detected"; ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent'';
  };
  home.file.".gnupg/sshcontrol" = {
    text = sshcontrol_value;
    onChange = "${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent";
  };

  programs = {
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
        plugins = ["git"];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        pfetch
      ''; # Zsh theme
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
