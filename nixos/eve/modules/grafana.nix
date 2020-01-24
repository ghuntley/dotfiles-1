{ pkgs, config, ... }: {

  services.grafana = {
    enable = true;
    domain = "grafana.thalheim.io";
    rootUrl = "https://grafana.thalheim.io";
    analytics.reporting.enable = false;
    extraOptions = {
      SERVER_ENFORCE_DOMAIN = "true";
      AUTH_LDAP_ENABLED = "true";
      AUTH_LDAP_CONFIG_FILE = "/run/grafana/ldap.toml";
    };
    smtp = {
      host = "mail.higgsboson.tk:587";
      user = "grafana@thalheim.io";
      passwordFile = "/run/keys/grafana-smtp-password";
      fromAddress = "grafana@thalheim.io";
    };
    database = {
      type = "postgres";
      name = "grafana";
      host = "/run/postgresql";
      user = "grafana";
    };
    security.adminPasswordFile = "/run/keys/grafana-admin-password";
    addr = "0.0.0.0";
    port = 3001;
  };

  users.users.grafana.extraGroups = [ "keys" ];
  systemd.services.grafana = {
    serviceConfig = {
      SupplementaryGroups = [ "keys" ];
      RuntimeDirectory = ["grafana"];
    };
    preStart = let
      ldap = pkgs.writeTextFile {
        name = "ldap.toml";
        text = ''
          [[servers]]
          host = "127.0.0.1"
          port = 389
          bind_dn = "cn=grafana,ou=system,ou=users,dc=eve"
          bind_password = "@bindPassword@"
          search_filter = "(&(objectClass=grafana)(|(mail=%s)(uid=%s)))"
          search_base_dns = ["ou=users,dc=eve"]

          [servers.attributes]
          name = "givenName"
          surname = "sn"
          username = "uid"
          email =  "mail"
        '';
      };
    in ''
      umask 077 
      sed -e "s/@bindPassword@/$(cat /run/keys/grafana-ldap-password)/" ${ldap} > /run/grafana/ldap.toml

      for i in `seq 1 10`; do
        if pg_isready; then
          break
        fi
        sleep 1
      done
    '';
  };

  services.nginx = {
    virtualHosts."grafana.thalheim.io" = {
      useACMEHost = "thalheim.io";
      forceSSL = true;
      locations."/".extraConfig = ''
        proxy_pass http://localhost:3001;
      '';
    };
  };

  services.netdata.httpcheck.checks.grafana = {
    url = "https://grafana.thalheim.io";
    regex = "Grafana";
  };

  services.icinga2.extraConfig = ''
    apply Service "Grafana v4 (eve)" {
      import "eve-http4-service"
      vars.http_vhost = "grafana.thalheim.io"
      vars.http_uri = "/"
      assign where host.name == "eve.thalheim.io"
    }

    apply Service "Grafana v6 (eve)" {
      import "eve-http6-service"
      vars.http_vhost = "grafana.thalheim.io"
      vars.http_uri = "/"
      assign where host.name == "eve.thalheim.io"
    }
  '';

  krops.secrets.files = {
    grafana-smtp-password.owner = "grafana";
    grafana-admin-password.owner = "grafana";
    grafana-ldap-password.owner = "grafana";
  };

  services.openldap.extraConfig = ''
    objectClass ( 1.3.6.1.4.1.28293.1.2.5 NAME 'grafana'
            SUP uidObject AUXILIARY
            DESC 'Added to an account to allow grafana access'
            MUST (mail) )
  '';
}