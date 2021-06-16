FROM vaultwarden/server:latest

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
      mariadb-client \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh
