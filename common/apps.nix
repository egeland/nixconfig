{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI tools
    bat
    fd
    git
    gnupg
    lazygit
    lsd
    pfetch-rs
    pinentry_mac
    yubikey-personalization
    yubikey-manager
    pwgen
    zellij

    # Editors
    neovim

    # terminal stuff
    #alacritty

    # Build tools
    just

    # rust stuff
    rustup

    # nodejs
    nodejs_22
    deno

    # language server stuff
    shellcheck
    marksman

    # Misc
    typst
    graphviz
    gh
    rectangle
    dockutil
    # mods

    # Java
    # jdk
  ];
}
