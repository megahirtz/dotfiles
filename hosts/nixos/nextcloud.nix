{config, pkgs, ...}:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    hostName = "nextcloud.megahirtz.run";
    https = true;
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "05:00:00";
    config = {
      overwriteProtocol = "https";

      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      dbpassFile = "${config.age.secrets.nextcloud-admin.path}";

      adminpassFile = "${config.age.secrets.nextcloud-db.path}";
      adminuser = "admin";
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
     { name = "nextcloud";
       ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
     }
    ];
  };
  #services.postgresqlBackup = {
  #  enable = true;
  #  databases = [ "nextcloud" ];
  #  location = /mnt/nextcloud;
  #};
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
}
