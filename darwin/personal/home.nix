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
      alacritty
      bat
      delta
      fish
      fzf
      gnupg
      hugo
      kitty
      lazygit
      lsd
      pfetch
      pinentry_mac
      #python310
      #python310Packages.ipython
      #python310Packages.pip
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
    alacritty = {
	  enable = true;
	  package = pkgs.alacritty;
	  settings = {
	  	font = {
		  size = 18.0;
	  	  normal = {
	  	    family = "FiraCode Nerd Font";
	  	    style = "Regular";
	  	  };
	  	  bold = {
	  	    family = "FiraCode Nerd Font";
	  	    style = "Bold";
	  	  };
	  	};
		window = {
		  dimensions = {
		    columns = 100;
		    lines = 30;
		  };
		  position = {
		    x = 0;
		    y = 0;
		  };
		  padding = {
		    x = 10;
		    y = 10;
		  };
		  # dynamicPadding = true;
		  decorations = "Full";
		  opacity = 0.95;
		};
		scrolling = {
		  historySize = 10000;
		};
		mouse = {
		  hideWhenTyping = true;
		};
	  };
	};
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode;
      enableExtensionUpdateCheck = true;
      extensions = with pkgs;
        [
          vscode-extensions.bbenoist.nix
          vscode-extensions.bungcip.better-toml
          vscode-extensions.donjayamanne.githistory
          vscode-extensions.kamadorueda.alejandra
          vscode-extensions.mhutchie.git-graph
          vscode-extensions.ms-python.python
          vscode-extensions.oderwat.indent-rainbow
          vscode-extensions.rust-lang.rust-analyzer
          vscode-extensions.serayuzgur.crates
          vscode-extensions.timonwong.shellcheck
          vscode-extensions.yzhang.markdown-all-in-one
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "prettier-rust";
            publisher = "jinxdash";
            version = "0.1.9";
            sha256 = "sha256-pb3I0NT72wKlnhw3O3vumia13tqXU3wbYi33WsI/uY0=";
          }
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
      syntaxHighlighting.enable = true;
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
    neovim = 
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
		{
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;

			plugins = with pkgs.vimPlugins; [
				# Quality of life
				vim-lastplace # Opens document where you left it
				auto-pairs # Print double quotes/brackets/etc.
				vim-gitgutter # See uncommitted changes of file :GitGutterEnable
				{
					plugin = whitespace-nvim;
					config = toLua "require(\"whitespace-nvim\").setup()";
				}
				{
					plugin = comment-nvim;
					config = toLua "require(\"Comment\").setup()";
				}
				vim-fugitive

				# File Tree
				{
					plugin = nvim-tree-lua;
					config = toLua "require(\"nvim-tree\").setup()";
				}

				# Customization
				{
					plugin = tokyonight-nvim;
					config = "colorscheme tokyonight";
				}
				nvim-lightline-lsp # LSP integration for lightline
				{
					plugin = lightline-vim; # Info bar at bottom
					config = ''${builtins.readFile ../common/nvim/lightline.vim}'';
				}
				indent-blankline-nvim # Indentation lines

				# AI
				copilot-vim

				# Treesitter
				{
					plugin = nvim-treesitter;
					config = toLuaFile ../common/nvim/treesitter.lua;
				}
				nvim-treesitter-parsers.bash
				nvim-treesitter-parsers.json
				nvim-treesitter-parsers.lua
				nvim-treesitter-parsers.markdown
				nvim-treesitter-parsers.nix
				nvim-treesitter-parsers.python
				nvim-treesitter-parsers.requirements
				nvim-treesitter-parsers.rust
				nvim-treesitter-parsers.toml
				nvim-treesitter-parsers.yaml

				# Languages
				plenary-nvim
				{
					plugin = telescope-nvim;
					config = toLuaFile ../common/nvim/telescope.lua;
				}
				{
					plugin = nvim-cmp;
					config = toLuaFile ../common/nvim/cmp.lua;
				}
				cmp-nvim-lsp
				cmp-git
				cmp-treesitter

				nvim-lspconfig
				luasnip
				lsp-zero-nvim
				rust-tools-nvim
				{
					plugin = crates-nvim;
					config = toLua "require(\"crates\").setup()";
				}
			];

			extraLuaConfig = ''
				${builtins.readFile ../common/nvim/options.lua}
				${builtins.readFile ../common/nvim/lsp.lua}
			'';
		};
  };
  services = {
  };
}
