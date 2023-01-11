#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
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
    computerName = "high-hrothgar"; # Host name
    hostName = "high-hrothgar";
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
      "~/bin"
      "/opt/homebrew/bin"
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
    karabiner-elements.enable = true;
  };

  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true; # Auto update packages
      # cleanup = "uninstall"; # Uninstall not listed packages and casks
    };
    taps = [
      "gromgit/fuse"
    ];
    brews = [
      "dvorak7min"
      "klavaro"
    ];
    casks = [
      "google-chrome"
      "macfuse"
      "freecad"
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
      # ./darwin/personal/dock.sh; # set up the dock
      # /etc/profiles/per-user/frode/bin/gpgconf --kill gpg-agent; echo "=== START A NEW SHELL NOW ==="
      # ${pkgs.gnupg}/bin/gpg --search-key $(gpg --card-status | awk '/General key/ { sub(/.*\//, "", $5); print $5}')
    '';
    stateVersion = 4;
  };
}
