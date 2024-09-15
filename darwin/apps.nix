{ ... }:
{
  # Requires Homebrew to be installed
  system.activationScripts.preUserActivation.text = ''
    if ! xcode-select --version 2>/dev/null; then
      $DRY_RUN_CMD xcode-select --install
    fi
    if ! /usr/local/bin/brew --version 2>/dev/null; then
      $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew = {
    enable = true;

    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    masApps = {
      Monosnap = 540348655;
    };

    taps = [
      #      "homebrew/cask-fonts"
      "homebrew/services"
      #      "homebrew/cask-versions"
      # {
      #   name = "popcorn-official/popcorn-desktop";
      #   clone_target = "https://github.com/popcorn-official/popcorn-desktop.git";
      # }
    ];

    brews = [
      "dvorak7min"
    ];

    casks = [
      # "raycast"
      "alacritty"

      "discord"

      "docker"

      "vlc"

      "brave-browser"
      "google-chrome"
    ];
  };
}
