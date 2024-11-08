{ lib
, useremail
, ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    # TODO replace with your own name & email
    userName = "Frode Egeland";
    userEmail = useremail;

    includes = [
      {
        # use diffrent email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

    ignores = [
      # Vim/Emacs
      "*~"
      ".*.swp"

      # Mac
      ".DS_Store"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"

      # Helix
      ".helix/"

      # VSCode Workspace Folder
      ".vscode/"

      # Rust
      "debug/"
      "target/"

      # Python
      "*.pyc"
      "*.egg"
      "*.out"
      "venv/"
      "**/**/__pycache__/"

      # Nix
      "result"
      "result-*"

      # direnv
      ".direnv"
      ".envrc"

      # NodeJS/Web dev
      ".env/"
      "node_modules"
      ".sass-cache"
    ];
    signing = {
      key = "0x6249C5087F5382D2";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
        navigate = true;
        light = false;
        syntax-theme = "catppuccin";
      };
    };

    aliases = {
      # common aliases
      amend = "commit --amend -m";
      br = "branch";
      ca = "commit -am";
      cb = "checkout -b";
      ci = "commit --signoff";
      cm = "commit -m";
      co = "checkout";
      dc = "diff --cached";
      lg = "log --oneline --abbrev-commit --all --graph --decorate --color --show-signature --no-merges";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      prp = "pull --rebase --prune";
      st = "status";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };
}
