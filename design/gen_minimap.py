# -*- coding: utf-8 -*-
"""Gera um minimapa base (.otmm) com o mapa inteiro em tom escuro.

Objetivo: o jogador abre o minimapa e ja ve o contorno do mundo, apagado.
Conforme anda, o proprio cliente sobrescreve cada tile com a cor real
recebida pelo protocolo e marca MinimapTileWasSeen -- o que foi explorado
"acende".

Por que funciona sem recompilar o cliente:
  MinimapBlock::update() desenha o tile pela cor e NAO consulta o
  WasSeen. Entao basta o arquivo base trazer as cores ja escurecidas;
  andar substitui pela cor verdadeira.

Por que nao lemos a cor real de cada item: isso exigiria resolver
items.otb (id de servidor -> cliente) e o Tibia.dat (minimapColor por
id), dois formatos binarios a mais. Para o efeito pedido basta saber
ONDE existe chao, e isso o OTBM ja diz sozinho.

Formato do OTMM (de Minimap::saveOtmm em src/client/minimap.cpp):
  u32 assinatura 0x4D4D544F ("OTMM")
  u16 inicio dos dados   u16 versao (1)   u32 flags (0)
  u16 tamanho + "OTMM 1.0"
  por bloco de 64x64:
     u16 x   u16 y   u8 z   u16 tamanho   dados zlib
     (bloco = 64*64 structs MinimapTile de 3 bytes: flags, color, speed)
  terminador: u16 0, u16 0, u8 0
"""
import os
import struct
import sys
import zlib
from collections import defaultdict

# --- OTBM ------------------------------------------------------------------
NODE_START, NODE_END, ESCAPE = 0xFE, 0xFF, 0xFD
OTBM_TILE_AREA, OTBM_TILE, OTBM_HOUSETILE = 4, 5, 14

# --- OTMM ------------------------------------------------------------------
OTMM_SIGNATURE = 0x4D4D544F
OTMM_VERSION = 1
MMBLOCK = 64
TILE_STRUCT = 3                      # flags, color, speed
BLOCK_BYTES = MMBLOCK * MMBLOCK * TILE_STRUCT
NO_TILE = 255                        # UINT8_MAX: nao desenhado

# Flags do tile base. Deliberadamente SEM MinimapTileWasSeen:
#  - a persistencia ja esta garantida, porque loadOtmm chama justSaw() em
#    cada bloco carregado e saveOtmm so descarta bloco nunca visto;
#  - e o pathfinder (map.cpp) bloqueia o tile quando NotWalkable ou
#    NotPathable estao ligados, entao marcando os dois ele nao traca rota
#    por regiao que o jogador ainda nao explorou -- ao andar, updateTile
#    substitui o tile inteiro pelas flags reais.
MINIMAP_NOT_PATHABLE = 2
MINIMAP_NOT_WALKABLE = 4
BASE_FLAGS = MINIMAP_NOT_PATHABLE | MINIMAP_NOT_WALKABLE

# Cor 8-bit do cliente: r=(c/36%6)*51, g=(c/6%6)*51, b=(c%6)*51.
# 43 -> (51,51,51): cinza escuro, visivel sobre o fundo preto sem competir
# com as cores reais que aparecem ao explorar.
DARK_COLOR = 43
DEFAULT_SPEED = 10


def parse_otbm_tiles(path):
    """Devolve {(z): {(x, y)}} com toda posicao que tem chao."""
    data = open(path, 'rb').read()
    n = len(data)
    tiles = defaultdict(set)

    i = 4                             # pula o cabecalho de versao
    stack = []                        # tipos dos nos abertos
    area = None                       # (baseX, baseY, z) do TILE_AREA atual

    while i < n:
        b = data[i]

        if b == NODE_START:
            i += 1
            node_type = data[i]
            i += 1
            stack.append(node_type)

            # As propriedades vao ate o proximo marcador de no.
            props = bytearray()
            while i < n:
                c = data[i]
                if c == ESCAPE:
                    props.append(data[i + 1])
                    i += 2
                elif c in (NODE_START, NODE_END):
                    break
                else:
                    props.append(c)
                    i += 1

            if node_type == OTBM_TILE_AREA and len(props) >= 5:
                bx, by, bz = struct.unpack_from('<HHB', props, 0)
                area = (bx, by, bz)
            elif node_type in (OTBM_TILE, OTBM_HOUSETILE) and area and len(props) >= 2:
                dx, dy = props[0], props[1]
                bx, by, bz = area
                tiles[bz].add((bx + dx, by + dy))

        elif b == NODE_END:
            if stack:
                closed = stack.pop()
                if closed == OTBM_TILE_AREA:
                    area = None
            i += 1
        else:
            i += 1                    # lixo entre nos: ignora

    return tiles


def write_otmm(tiles, out_path):
    """Escreve o .otmm com um bloco por regiao 64x64 que tenha chao."""
    out = bytearray()
    out += struct.pack('<I', OTMM_SIGNATURE)
    out += struct.pack('<H', 0)       # inicio dos dados: corrigido adiante
    out += struct.pack('<H', OTMM_VERSION)
    out += struct.pack('<I', 0)       # flags
    desc = b'OTMM 1.0'
    out += struct.pack('<H', len(desc)) + desc

    start = len(out)
    struct.pack_into('<H', out, 4, start)

    blocks = 0
    for z in sorted(tiles.keys()):
        grouped = defaultdict(list)
        for (x, y) in tiles[z]:
            grouped[(x - x % MMBLOCK, y - y % MMBLOCK)].append((x, y))

        for (bx, by), positions in sorted(grouped.items()):
            # Bloco cheio de "sem tile"; so as posicoes com chao recebem cor.
            buf = bytearray(BLOCK_BYTES)
            for off in range(0, BLOCK_BYTES, TILE_STRUCT):
                buf[off + 1] = NO_TILE
                buf[off + 2] = DEFAULT_SPEED

            for (x, y) in positions:
                idx = ((y % MMBLOCK) * MMBLOCK + (x % MMBLOCK)) * TILE_STRUCT
                buf[idx] = BASE_FLAGS
                buf[idx + 1] = DARK_COLOR
                buf[idx + 2] = DEFAULT_SPEED

            packed = zlib.compress(bytes(buf), 3)
            out += struct.pack('<HHBH', bx, by, z, len(packed))
            out += packed
            blocks += 1

    out += struct.pack('<HHB', 0, 0, 0)   # terminador
    open(out_path, 'wb').write(out)
    return blocks, len(out)


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    otbm, out = sys.argv[1], sys.argv[2]

    print('lendo %s (%.1f MB)...' % (otbm, os.path.getsize(otbm) / 1048576))
    tiles = parse_otbm_tiles(otbm)
    total = sum(len(v) for v in tiles.values())
    print('andares: %s' % sorted(tiles.keys()))
    print('tiles com chao: %d' % total)

    blocks, size = write_otmm(tiles, out)
    print('escrito %s: %d blocos, %.1f MB' % (out, blocks, size / 1048576))
    return 0


if __name__ == '__main__':
    sys.exit(main())
