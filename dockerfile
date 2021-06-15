# syntax=docker/dockerfile:1
FROM vaultwarden/server:latest
COPY start.sh /start.sh
CMD chmod +x /start.sh
