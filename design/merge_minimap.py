# -*- coding: utf-8 -*-
"""Mescla um minimapa ja explorado sobre o minimapa base escuro.

Quem ja jogou tem um minimap.otmm com as areas que andou, em cores reais.
Instalar a base por cima apagaria isso. Aqui a base entra por baixo: cada
tile ja explorado vence, o resto fica no tom escuro.

Uso:
    python merge_minimap.py <base.otmm> <explorado.otmm> <saida.otmm>
"""
import struct
import sys
import zlib

MMBLOCK = 64
TILE_STRUCT = 3
BLOCK_BYTES = MMBLOCK * MMBLOCK * TILE_STRUCT
NO_TILE = 255
OTMM_SIGNATURE = 0x4D4D544F
OTMM_VERSION = 1


def read_otmm(path):
    """Devolve {(x, y, z): bytes do bloco descomprimido}."""
    data = open(path, 'rb').read()
    sig, start, ver, _flags = struct.unpack_from('<IHHI', data, 0)
    if sig != OTMM_SIGNATURE:
        raise SystemExit('%s nao e um OTMM valido' % path)
    if ver != OTMM_VERSION:
        raise SystemExit('%s tem versao %d, esperado %d' % (path, ver, OTMM_VERSION))

    blocks = {}
    i = start
    while i + 7 <= len(data):
        x, y, z, ln = struct.unpack_from('<HHBH', data, i)
        i += 7
        if x == 0 and y == 0 and z == 0:
            break                     # terminador
        raw = zlib.decompress(data[i:i + ln])
        if len(raw) != BLOCK_BYTES:
            raise SystemExit('bloco (%d,%d,%d) com tamanho inesperado' % (x, y, z))
        blocks[(x, y, z)] = bytearray(raw)
        i += ln
    return blocks


def write_otmm(blocks, path):
    out = bytearray()
    out += struct.pack('<I', OTMM_SIGNATURE)
    out += struct.pack('<H', 0)
    out += struct.pack('<H', OTMM_VERSION)
    out += struct.pack('<I', 0)
    desc = b'OTMM 1.0'
    out += struct.pack('<H', len(desc)) + desc

    start = len(out)
    struct.pack_into('<H', out, 4, start)

    for (x, y, z) in sorted(blocks.keys(), key=lambda k: (k[2], k[0], k[1])):
        packed = zlib.compress(bytes(blocks[(x, y, z)]), 3)
        out += struct.pack('<HHBH', x, y, z, len(packed))
        out += packed

    out += struct.pack('<HHB', 0, 0, 0)
    open(path, 'wb').write(out)
    return len(out)


def main():
    if len(sys.argv) < 4:
        print(__doc__)
        return 1
    base_path, explored_path, out_path = sys.argv[1], sys.argv[2], sys.argv[3]

    base = read_otmm(base_path)
    explored = read_otmm(explored_path)
    print('base: %d blocos | explorado: %d blocos' % (len(base), len(explored)))

    kept = 0
    for key, blk in explored.items():
        target = base.setdefault(key, bytearray(blk))
        for off in range(0, BLOCK_BYTES, TILE_STRUCT):
            # Tile com cor valida no arquivo explorado sobrepoe o base.
            if blk[off + 1] != NO_TILE:
                target[off:off + TILE_STRUCT] = blk[off:off + TILE_STRUCT]
                kept += 1

    size = write_otmm(base, out_path)
    print('tiles explorados preservados: %d' % kept)
    print('escrito %s: %d blocos, %.1f MB' % (out_path, len(base), size / 1048576))
    return 0


if __name__ == '__main__':
    sys.exit(main())
