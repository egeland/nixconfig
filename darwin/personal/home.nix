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
      # darwin.xcode
      delta
      fish
      fzf
      gnupg
      hugo
      lazygit
      lsd
      neovim
      pfetch
      pinentry_mac
      pwgen
      rectangle
      starship
      tree
      wget
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
        keyserver = "hkps://pgp.mit.edu";
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
    neovim = {
			enable = false;
			defaultEditor = false;
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;
		};
  };
  services = {
  };
}
