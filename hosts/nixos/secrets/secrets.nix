let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIU/qYWse1/OvAmbH0RAbJfOyR7Zu/eEbXbUzs6IDAzn";
  user2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqwUVkDlxSfX7qJ/+o/JRwPW/HmfX2zhMWrR+z5kxyR";
  users = [ user1 user2 ];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8fbEi+Dv3Bjaaj3mzrX4MmJWB227NmL6DrynaExXSe";
  system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYoBBACBx5I5X5ewXpQkYN5vwhw9uETL+h3V1WTKtEN";
  systems = [ system1 system2];
in
{
  "nextcloud-admin.age".publicKeys = users ++ systems;
  "nextcloud-db.age".publicKeys = users ++ systems;
  "vaultwarden-env.age".publicKeys = users ++ systems;
  "email-address.age".publicKeys = users ++ systems;
}
