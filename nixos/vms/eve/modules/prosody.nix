{ pkgs, ... }: {
  services.prosody = {
    enable = true;
    admins = [ 
      "joerg@thalheim.io"
      "devkid@devkid.net"
    ];
    extraConfig = ''
      consider_bosh_secure = true
      cross_domain_bosh = {
        "thalheim.io", 
        "devkid.net", 
        "higgsboson.tk",
        "muc.higgsboson.tk",
        "anon.higgsboson.tk"
      }
      default_archive_policy = true
      proxy65_ports = {
        6555
      }
      allow_registration = false

      authentication = "ldap"
      ldap_server = "127.0.0.1"
      ldap_tls = false
      ldap_base = "ou=users,dc=eve"
      ldap_scope = "subtree"
      ldap_filter = "(&(jabberID=$user@$host)(objectClass=jabberUser))"
      ldap_rootdn = "cn=prosody,ou=system,ou=users,dc=eve"
      ldap_password = (io.open("/run/keys/prosody-ldap-password", "r"):read("*a"))

      default_storage = "sql"
      storage = {
        -- This makes mod_mam use the sql2 storage backend (others will use internal)
        -- which at the time of this writing is the only one supporting stanza archives
        archive2 = "sql";
      }
      http_upload_file_size_limit = 20 * 1024 * 1024

      sql = { 
        driver = "PostgreSQL", 
        database = "prosody", 
        username = "prosody", 
        password = io.open("/run/keys/prosody-db-password", "r"):read("*a"),
        host = "172.23.75.10";
      }

      Component "muc.higgsboson.tk" "muc"
        modules_enabled = { "mam_muc"; }
      muc_log_by_default = true;
      muc_log_all_rooms = false;
      max_archive_query_results = 20;
      max_history_messages = 1000;
      -- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
      Component "jabber.higgsboson.tk" "proxy65"
      Component "proxy.higgsboson.tk" "proxy65"
      -- Feeds!
      Component "pubsub.higgsboson.tk" "pubsub"
      Component "jabber.higgsboson.tk" "http_upload"

      ssl = {
        extraOptions = {
          dhparam = "/var/lib/prosody/dh-2048.pem";
          ciphers = "HIGH+kEDH:HIGH+kEECDH:!DHE-RSA-AES128-GCM-SHA256:!DHE-RSA-AES128-SHA256:!ECDHE-RSA-AES128-GCM-SHA256:!ECDHE-RSA-AES128-SHA256:!ECDHE-RSA-AES128-SHA:!AES128-GCM-SHA256:!AES256-GCM-SHA384:!AES256-SHA256:AES128-SHA256:!CAMELLIA256-SHA:AES256-SHA:!DHE-RSA-CAMELLIA128-SHA:!DHE-DSS-CAMELLIA128-SHA:!DHE-RSA-AES128-SHA:!DHE-DSS-AES128-SHA:HIGH:!CAMELLIA128-SHA:!AES128-SHA:!SRP:!3DES:!aNULL";
        };
      };
    '';
    s2sSecureDomains = [
      "jabber.c3d2.de"
    ];
    modules = {
      mam = true;
      bosh = true;
      http_files = true;
      watchregistrations = true;
      proxy65 = true;
    };
    virtualHosts = {
      thalheim = {
        domain = "thalheim.io";
        enabled = true;
      };
      higgsboson = {
        domain = "higgsboson.tk";
        enabled = true;
      };
      devkid = {
        domain = "devkid.net";
        enabled = true;
      };
      w01f = {
        domain = "w01f.de";
        enabled = true;
      };
      anon = {
        enabled = true;
        domain = "anon.higgsboson.tk";
        extraConfig = ''
          authentication = "anonymous"
        '';
      };
    };
    package = pkgs.prosody.override {
      #withExtraLibs = [ pkgs.luaPackages.lpty ];
      withExtraLibs = [ 
        (pkgs.callPackage ../pkgs/lualdap.nix {})
      ];
      withCommunityModules = [ 
        "smacks"
        "smacks_offline"
        "csi"
        "cloud_notify"
        "throttle_presence"
        "http_upload"
        "pep_vcard_avatar"
        "auth_ldap"
      ];
    };
  };

  users.users.prosody.extraGroups = [ "keys" ];
  systemd.services.prosody.serviceConfig.SupplementaryGroups = [ "keys" ];

  services.tor.hiddenServices."jabber".map = [
    { port = "5222"; }
    { port = "5269"; }
  ];

  deployment.keys = {
    "prosody-ldap-password" = {
      keyFile = ../secrets/prosody-ldap-password;
      user = "prosody";
    };
    "prosody-db-password" = {
      keyFile = ../secrets/prosody-db-password;
      user = "prosody";
    };
  };
}