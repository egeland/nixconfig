{ pkgs, config, ... }: {
  home.file."${config.home.homeDirectory}/.gnupg/gpg-agent.conf" =
    {
      text = ''default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
pinentry-program "${pkgs.pinentry_mac}/bin/pinentry-mac"
'';
      onChange = ''echo "gpg-agent change detected"; ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent'';
    };

  home.file."${config.home.homeDirectory}/.gnupg/sshcontrol" =
    {
      text = "032896FEEFADEBAF209C345A90DE6FDDD9BB2A1B";
      onChange = ''echo "gpg-agent change detected"; ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent; ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent'';
    };
  programs.gpg = {
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
}
