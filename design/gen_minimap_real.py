# -*- coding: utf-8 -*-
"""Gera o minimapa base com o RELEVO REAL do mundo, escurecido.

A primeira versao (gen_minimap.py) pintava todo tile de um cinza unico:
mostrava o contorno, mas nao dava nocao de agua, floresta ou cidade. Aqui
cada tile recebe a cor de minimapa de verdade, rebaixada -- e ao andar o
cliente substitui pela cor cheia, entao o explorado "acende".

Sao tres arquivos encadeados, porque a cor nao esta no mapa:

  PGalaxy.otbm  ->  id de SERVIDOR do que existe em cada posicao
  items.otb     ->  id de servidor  ->  id de CLIENTE
  Tibia.dat     ->  id de cliente   ->  cor de minimapa (indice 8 bits)

A escolha de qual item manda na cor imita Tile::getMinimapColorByte do
cliente: varre do topo para baixo e fica com a primeira cor nao-zero.

Uso:
    python gen_minimap_real.py <map.otbm> <items.otb> <Tibia.dat> <saida.otmm>
"""
import os
import struct
import sys
import zlib
from collections import defaultdict

# --- arvore de nos, comum a OTBM e OTB -------------------------------------
NODE_START, NODE_END, ESCAPE = 0xFE, 0xFF, 0xFD

# --- OTBM ------------------------------------------------------------------
OTBM_TILE_AREA, OTBM_TILE, OTBM_ITEM, OTBM_HOUSETILE = 4, 5, 6, 14
OTBM_ATTR_ITEM = 9
OTBM_ATTR_TILE_FLAGS = 3

# --- OTB -------------------------------------------------------------------
ITEM_ATTR_SERVERID, ITEM_ATTR_CLIENTID = 0x10, 0x11

# --- OTMM ------------------------------------------------------------------
OTMM_SIGNATURE = 0x4D4D544F
OTMM_VERSION = 1
MMBLOCK = 64
TILE_STRUCT = 3
BLOCK_BYTES = MMBLOCK * MMBLOCK * TILE_STRUCT
NO_TILE = 255

# Ver comentario em gen_minimap.py: sem WasSeen, e com NotWalkable |
# NotPathable para o pathfinder nao tracar rota por area inexplorada.
BASE_FLAGS = 2 | 4
DEFAULT_SPEED = 10

# Fator de escurecimento por componente da paleta 6x6x6 do cliente.
# 0.45 deixa o relevo legivel mas claramente "apagado" ao lado da cor
# cheia que aparece quando o jogador explora.
DARK_FACTOR = 0.45
NEUTRAL_DARK = 43                    # (51,51,51): usado quando escurecer daria preto


def darken(color8):
    """Rebaixa um indice da paleta 6x6x6 mantendo o matiz."""
    if color8 <= 0 or color8 >= 216:
        return None
    r, g, b = color8 // 36 % 6, color8 // 6 % 6, color8 % 6
    r = int(r * DARK_FACTOR + 0.5)
    g = int(g * DARK_FACTOR + 0.5)
    b = int(b * DARK_FACTOR + 0.5)
    idx = r * 36 + g * 6 + b
    # Indice 0 e transparente no cliente: o tile sumiria do mapa.
    return idx if idx > 0 else NEUTRAL_DARK


# ---------------------------------------------------------------------------
# items.otb: id de servidor -> id de cliente
# ---------------------------------------------------------------------------
def parse_otb(path):
    data = open(path, 'rb').read()
    n = len(data)
    mapping = {}
    i = 4                                    # pula a versao

    while i < n:
        if data[i] != NODE_START:
            i += 1
            continue
        i += 1
        i += 1                               # tipo do no (grupo do item)

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

        # props: u32 flags, depois {u8 attr, u16 tamanho, dados}
        if len(props) < 4:
            continue
        p, srv, cli = 4, None, None
        while p + 3 <= len(props):
            attr = props[p]
            size = struct.unpack_from('<H', props, p + 1)[0]
            p += 3
            if p + size > len(props):
                break
            if attr == ITEM_ATTR_SERVERID and size >= 2:
                srv = struct.unpack_from('<H', props, p)[0]
            elif attr == ITEM_ATTR_CLIENTID and size >= 2:
                cli = struct.unpack_from('<H', props, p)[0]
            p += size
        if srv is not None and cli is not None:
            mapping[srv] = cli

    return mapping


# ---------------------------------------------------------------------------
# Tibia.dat: id de cliente -> cor de minimapa
# ---------------------------------------------------------------------------
class Reader:
    def __init__(self, data):
        self.d, self.i = data, 0

    def u8(self):
        v = self.d[self.i]; self.i += 1; return v

    def u16(self):
        v = struct.unpack_from('<H', self.d, self.i)[0]; self.i += 2; return v

    def u32(self):
        v = struct.unpack_from('<I', self.d, self.i)[0]; self.i += 4; return v


# Atributos que carregam dados, ja na numeracao pos-remapeamento do 8.54.
# (raw == 8 vira "chargeable" sem dados; raw > 8 e decrementado em 1.)
ATTR_U16 = {0, 8, 9, 25, 28, 29, 32}     # ground, writable, writableOnce,
                                          # elevation, minimapColor, lensHelp, cloth
ATTR_2xU16 = {21, 24}                     # light, displacement
ATTR_MINIMAP = 28


def parse_dat(path):
    r = Reader(open(path, 'rb').read())
    r.u32()                                   # assinatura
    item_count = r.u16()
    r.u16(); r.u16(); r.u16()                 # outfits, efeitos, projeteis

    colors = {}
    for thing_id in range(100, item_count + 1):
        minimap = 0
        while True:
            attr = r.u8()
            if attr == 0xFF:
                break
            if attr == 8:                     # chargeable: sem dados
                continue
            if attr > 8:
                attr -= 1
            if attr in ATTR_2xU16:
                r.u16(); r.u16()
            elif attr in ATTR_U16:
                v = r.u16()
                if attr == ATTR_MINIMAP:
                    minimap = v

        # bloco de sprites: precisa ser consumido para nao perder o sincronismo
        w, h = r.u8(), r.u8()
        if w > 1 or h > 1:
            r.u8()                            # realSize
        layers, px, py = r.u8(), r.u8(), r.u8()
        pz = r.u8()                           # >= 755
        phases = r.u8()
        total = w * h * layers * px * py * pz * phases
        # Ids de sprite em u32: este .dat usa sprites estendidos
        # (GameSpritesU32). Da para conferir a olho nos primeiros itens --
        # eles saem como 7C 00 00 00, 7D 00 00 00, ... Com u16 o parser
        # dessincroniza e estoura o fim do arquivo.
        r.i += total * 4

        if minimap:
            colors[thing_id] = minimap

    return colors


# ---------------------------------------------------------------------------
# OTBM: posicao -> lista de ids de servidor (chao primeiro, topo por ultimo)
# ---------------------------------------------------------------------------
def parse_otbm(path):
    data = open(path, 'rb').read()
    n = len(data)
    tiles = defaultdict(dict)                 # z -> {(x, y): [ids]}

    # Dimensoes declaradas no no raiz: u32 versao, u16 largura, u16 altura.
    # Servem de limite -- a varredura por bytes as vezes confunde dados de
    # item com inicio de no e inventa posicoes absurdas (x perto de 65535).
    # Sem esse filtro elas entram no arquivo final e o mapa fica torto.
    map_w, map_h = 65535, 65535
    if n > 15 and data[4] == NODE_START:
        map_w, map_h = struct.unpack_from('<HH', data, 10)

    i = 4
    stack = []
    area = None
    cur = None                                # lista de ids do tile aberto

    while i < n:
        b = data[i]

        if b == NODE_START:
            i += 1
            node_type = data[i]
            i += 1
            stack.append(node_type)

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
                area = struct.unpack_from('<HHB', props, 0)

            elif node_type in (OTBM_TILE, OTBM_HOUSETILE) and area and len(props) >= 2:
                dx, dy = props[0], props[1]
                bx, by, bz = area
                px, py = bx + dx, by + dy
                if px > map_w or py > map_h:
                    cur = []                  # fora do mapa: le e descarta
                else:
                    cur = []
                    tiles[bz][(px, py)] = cur

                # O chao costuma vir como atributo do proprio tile. Os
                # atributos podem vir em qualquer ordem, entao as flags
                # precisam ser puladas -- parar no primeiro atributo
                # desconhecido faria perder o chao de todo tile com flag.
                p = 6 if node_type == OTBM_HOUSETILE else 2   # casa: u32 do id
                while p < len(props):
                    attr = props[p]
                    p += 1
                    if attr == OTBM_ATTR_ITEM and p + 2 <= len(props):
                        cur.append(struct.unpack_from('<H', props, p)[0])
                        p += 2
                    elif attr == OTBM_ATTR_TILE_FLAGS and p + 4 <= len(props):
                        p += 4
                    else:
                        break                 # atributo nao previsto: para aqui

            elif node_type == OTBM_ITEM and cur is not None and len(props) >= 2:
                cur.append(struct.unpack_from('<H', props, 0)[0])

        elif b == NODE_END:
            if stack:
                closed = stack.pop()
                if closed == OTBM_TILE_AREA:
                    area = None
                elif closed in (OTBM_TILE, OTBM_HOUSETILE):
                    cur = None
            i += 1
        else:
            i += 1

    return tiles


# ---------------------------------------------------------------------------
def write_otmm(colored, out_path):
    out = bytearray()
    out += struct.pack('<I', OTMM_SIGNATURE)
    out += struct.pack('<H', 0)
    out += struct.pack('<H', OTMM_VERSION)
    out += struct.pack('<I', 0)
    desc = b'OTMM 1.0'
    out += struct.pack('<H', len(desc)) + desc
    start = len(out)
    struct.pack_into('<H', out, 4, start)

    blocks = 0
    for z in sorted(colored.keys()):
        grouped = defaultdict(list)
        for (x, y), c in colored[z].items():
            grouped[(x - x % MMBLOCK, y - y % MMBLOCK)].append((x, y, c))

        for (bx, by), items in sorted(grouped.items()):
            buf = bytearray(BLOCK_BYTES)
            for off in range(0, BLOCK_BYTES, TILE_STRUCT):
                buf[off + 1] = NO_TILE
                buf[off + 2] = DEFAULT_SPEED
            for (x, y, c) in items:
                idx = ((y % MMBLOCK) * MMBLOCK + (x % MMBLOCK)) * TILE_STRUCT
                buf[idx] = BASE_FLAGS
                buf[idx + 1] = c
                buf[idx + 2] = DEFAULT_SPEED
            packed = zlib.compress(bytes(buf), 3)
            out += struct.pack('<HHBH', bx, by, z, len(packed))
            out += packed
            blocks += 1

    out += struct.pack('<HHB', 0, 0, 0)
    open(out_path, 'wb').write(out)
    return blocks, len(out)


def main():
    if len(sys.argv) < 5:
        print(__doc__)
        return 1
    otbm_path, otb_path, dat_path, out_path = sys.argv[1:5]

    print('items.otb...')
    srv2cli = parse_otb(otb_path)
    print('  %d itens mapeados servidor->cliente' % len(srv2cli))

    print('Tibia.dat...')
    colors = parse_dat(dat_path)
    print('  %d itens com cor de minimapa' % len(colors))

    print('mapa (%.1f MB)...' % (os.path.getsize(otbm_path) / 1048576))
    tiles = parse_otbm(otbm_path)

    colored = defaultdict(dict)
    sem_cor = 0
    for z, positions in tiles.items():
        for pos, ids in positions.items():
            # Igual ao cliente: do topo para baixo, primeira cor nao-zero.
            chosen = None
            for sid in reversed(ids):
                cid = srv2cli.get(sid)
                if cid and colors.get(cid):
                    chosen = colors[cid]
                    break
            if chosen is None:
                sem_cor += 1
                continue
            d = darken(chosen)
            if d:
                colored[z][pos] = d

    total = sum(len(v) for v in colored.values())
    print('  tiles com cor: %d  (sem cor: %d)' % (total, sem_cor))

    blocks, size = write_otmm(colored, out_path)
    print('escrito %s: %d blocos, %.1f MB' % (out_path, blocks, size / 1048576))
    return 0


if __name__ == '__main__':
    sys.exit(main())
