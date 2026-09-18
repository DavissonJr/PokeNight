#!/bin/bash
set -e

# ---------------------------------------------------------------------------
# Correcao do IP entregue na lista de personagens.
#
# otserv.cpp monta serverIps assim:
#   1) 127.0.0.1                        mascara 0xFFFFFFFF (exata)
#   2) IPs de gethostbyname(hostname)   mascara 0x0000FFFF (/16)
#   3) o "ip" do config.lua             mascara 0        (casa com tudo)
#
# protocollogin.cpp devolve ao cliente o IP da PRIMEIRA entrada que casa
# com o IP de origem da conexao. Sob Docker o cliente chega NATeado pelo
# gateway (172.x.0.1), que casa com a entrada 2 pelo /16 -- e o servidor
# responde com o IP interno do container, inalcancavel a partir do Windows.
#
# Fazendo o hostname resolver para 127.0.0.1, a entrada 2 passa a ser
# 127.0.0.x, que nao casa com 172.x, e o fallback (entrada 3) vence.
# Usamos "cat >" em vez de "sed -i" porque /etc/hosts e um bind mount e
# precisa ser escrito preservando o inode.
# ---------------------------------------------------------------------------
HN="$(hostname)"
grep -v "[[:space:]]${HN}\([[:space:]]\|$\)" /etc/hosts > /tmp/hosts.new
echo "127.0.0.1 ${HN}" >> /tmp/hosts.new
cat /tmp/hosts.new > /etc/hosts
echo ">> hostname ${HN} agora resolve para: $(getent hosts ${HN} | awk '{print $1}')"

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
