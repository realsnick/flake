# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs
, username
, ...
}: {
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.docker.enable = true;
  users.groups.docker.members = [ "${username}" ];
}
