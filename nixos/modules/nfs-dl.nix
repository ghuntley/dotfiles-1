{
  fileSystems."/mnt/prism" = {
    device = "prism.r:/export/download";
    fsType = "nfs";
    options = [
      "timeo=14"
      "noauto"
      "noatime"
      "nodiratime"
      "noac"
      "nocto"
      "ro"
      "x-systemd.automount"
      "x-systemd.device-timeout=1"
      "x-systemd.idle-timeout=1min"
    ];
  };
}
