let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIU/qYWse1/OvAmbH0RAbJfOyR7Zu/eEbXbUzs6IDAzn";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqwUVkDlxSfX7qJ/+o/JRwPW/HmfX2zhMWrR+z5kxyR";

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8fbEi+Dv3Bjaaj3mzrX4MmJWB227NmL6DrynaExXSe";
  system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYoBBACBx5I5X5ewXpQkYN5vwhw9uETL+h3V1WTKtEN";
in
{
  "nextcloud-admin.age".publicKeys = [ user2 system2 ];
  "nextcloud-db.age".publicKeys = [ user2 system2 ];
  "vaultwarden-env.age".publicKeys = [ user2 system2];
}
