# O binario theforgottenserver foi compilado no Debian 11 e precisa de
# boost 1.74 + lua5.1 + libmariadb3. O bookworm entrega exatamente essas
# versoes e ainda tem repositorio ativo (o bullseye saiu do LTS em 08/2026).
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        libboost-system1.74.0 \
        libboost-filesystem1.74.0 \
        libboost-regex1.74.0 \
        libboost-thread1.74.0 \
        liblua5.1-0 \
        libmariadb3 \
        libxml2 \
        libgmp10 \
        libstdc++6 \
        tzdata \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Sao_Paulo
WORKDIR /srv

# Espera o MariaDB aceitar conexao antes de subir o TFS, senao ele
# aborta no startup com erro de conexao ao banco.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
