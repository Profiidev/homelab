FROM nixpkgs/nix:nixos-24.05

RUN mkdir -p /root/.config/nix
RUN echo experimental-features = nix-command flakes > /root/.config/nix/nix.conf
RUN nix profile install nixpkgs#sshpass nixpkgs#gnused nixpkgs#gnugrep
RUN mkdir /nixos

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]