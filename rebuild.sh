#!/bin/bash
ssh homelab-0 "cd homelab/nixos && git pull && sudo nixos-rebuild --flake .#homelab-0 switch" & \
ssh homelab-1 "cd homelab/nixos && git pull && sudo nixos-rebuild --flake .#homelab-1 switch" & \
ssh homelab-2 "cd homelab/nixos && git pull && sudo nixos-rebuild --flake .#homelab-2 switch"
