FROM lscr.io/linuxserver/rdesktop:latest

COPY nitriding/cmd/nitriding /bin/

CMD ["nitriding", "-fqdn", "nitro.nymity.ch"]
