{
  config,
  pkgs,
  user,
  lib,
  ...
}: {
  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.zsh; # Default shell
  };

  networking = {
    computerName = "Frode Egeland 2"; # Host name
    hostName = "Frode-Egeland-2";
  };

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [zsh]; # Default shell
    variables = {
      # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # Installed Nix packages
      git
      ranger
      fd
      ripgrep
      dockutil
    ];
    systemPath = [
      "/etc/profiles/per-user/frode/bin/libexec"
    ];
  };

  programs = {
    # Shell needs to be enabled
    zsh.enable = true;

    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };

  services = {
    nix-daemon.enable = true; # Auto upgrade daemon
  };

  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true; # Auto update packages
      #cleanup = "zap"; # Uninstall not listed packages and casks
    };
    brews = [
    ];
    casks = [
      "google-chrome"
      "slack"
      # "karabiner-elements"
    ];
    masApps = {
      Monosnap = 540348655;
    };
  };

  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];

  system = {
    defaults = {
      alf = {
        globalstate = 1;
        stealthenabled = 1;
        allowdownloadsignedenabled = 1;
      };
      NSGlobalDomain = {
        # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.swipescrolldirection" = false;
      };
      dock = {
        # Dock settings
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 50;
        show-recents = false;
      };
      finder = {
        # Finder settings
        QuitMenuItem = false; # I believe this probably will need to be true if using spacebar
      };
      trackpad = {
        # Trackpad settings
        Clicking = true;
        TrackpadRightClick = true;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
    };
    keyboard = {
      enableKeyMapping = true; # Needed for skhd
    };
    activationScripts.postActivation.text = ''
      # sudo chsh -s ${pkgs.zsh}/bin/zsh ; # Since it's not possible to declare default shell, run this command after build
      # ./darwin/dock.sh; # set up the dock
      # /etc/profiles/per-user/frode/bin/gpgconf --kill gpg-agent; echo "=== START A NEW SHELL NOW ==="
      # grep -A 22 -- '----BEGIN PGP PUBLIC KEY BLOCK-----' <(curl -s $(${pkgs.gnupg}/bin/gpg --card-status | grep 'URL of public key' | awk '{print $6}')) | ${pkgs.gnupg}/bin/gpg --import
    '';
    stateVersion = 4;
  };
}
