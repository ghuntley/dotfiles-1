let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbBp2dH2X3dcU1zh+xW3ZsdYROKpJd3n13ssOP092qE joerg@turingmachine";
in {
  users.extraUsers = {
    joerg = {
      isNormalUser = true;
      home = "/home/joerg";
      extraGroups = [ "wheel" "docker" "plugdev" "vboxusers" "adbusers" "input" ];
      shell = "/run/current-system/sw/bin/zsh";
      uid = 1000;
      openssh.authorizedKeys.keys = [ key ];
    };
    root.openssh.authorizedKeys.keys = [ key ];
  };

  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;
}