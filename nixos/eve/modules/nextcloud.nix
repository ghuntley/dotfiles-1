{ config, pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    hostName = "cloud.thalheim.io";

    caching.apcu = true;

    package = pkgs.nextcloud19;

    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbtableprefix = "oc_";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      adminuser = "nextcloudadmin";
      adminpassFile = config.sops.secrets.nextcloud-admin-password.path;
      extraTrustedDomains = [
        "pim.devkid.net"
      ];
    };

    poolSettings = {
      "pm" = "ondemand";
      "pm.max_children" = 32;
      "pm.process_idle_timeout" = "10s";
      "pm.max_requests" = 500;
    };
  };

  sops.secrets.nextcloud-admin-password.owner = "nextcloud";

  users.users.nextcloud.extraGroups = [ "keys" ];
  systemd.services.nextcloud.serviceConfig.SupplementaryGroups = [ "keys" ];

  services.nginx.virtualHosts."cloud.thalheim.io" = {
    useACMEHost = "thalheim.io";
    forceSSL = true;
    serverAliases = [ "pim.devkid.net" ];
  };
}
