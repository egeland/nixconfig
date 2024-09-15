{ pkgs, config, ... }: {
  home.file."${config.home.homeDirectory}/.config/nvim" = {
    recursive = true;
    source = ./nvim;
  };
}
