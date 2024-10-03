#!/bin/bash
ssh-keygen -f /root/.ssh/id_ed25519 -N ""
rm /root/.ssh/known_hosts

nix shell nixpkgs#sshpass nixpkgs#gnugrep nixpkgs#gnused \
  --command "sshpass" "-p" "$PASS" \
  "ssh-copy-id" "-o" "StrictHostKeyChecking=no" "root@$IP"

cd /nixos

nix run github:nix-community/nixos-anywhere \
         --extra-experimental-features "nix-command flakes" \
         -- --flake .#$CONFIG root@$IP