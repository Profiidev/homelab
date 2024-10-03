{ config, lib, pkgs, meta, ... }:

{
  imports = [];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/share/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = "json-file";

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/var/lib/rancher/k3s/server/token";
    extraFlags = toString ([
      "--write-kubeconfig-mode \"0644\""
      "--cluster-init"
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage"
    ] ++ (if meta.hostname == "homelab-0" then [] else [
      "--server https://homelab-0:6443"
    ]));
    clusterInit = (meta.hostname == "homelab-0");
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  };

  users.users.profidev = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$WXdj63wqFgyu0TC2$gTH9hrAvmk8SmVioywi5j3V/.qKEjFLYdfj8flGn1eHFvuhlv7/fw01TWbae38n24.qLAkoAJqQ1AGTw4TdO40";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVWNfJFz2uvoxPFHTHxN57W5GU49Nfvqa0scPSxROEy profidev@desktop-n5z690"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpQjcJocTgOcWHgatHS5tmqHubnOcgiLDmXcBNVZW4p root@arch"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    neovim
    k3s
    cifs-utils
    nfs-utils
    git
  ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
