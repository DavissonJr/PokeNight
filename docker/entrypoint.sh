#!/bin/bash
set -e

echo ">> Aguardando o MariaDB em ${DB_HOST:-db}:3306 ..."
until nc -z "${DB_HOST:-db}" 3306; do
    sleep 2
done
echo ">> MariaDB respondeu."

# O binario precisa de permissao de execucao; no bind mount vindo do
# Windows ela costuma vir perdida.
chmod +x /srv/theforgottenserver 2>/dev/null || true

echo ">> Iniciando o Poke Night..."
cd /srv
exec ./theforgottenserver
