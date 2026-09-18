# -*- coding: utf-8 -*-
"""Extrai as cidades do OTBM e gera a tabela Lua usada nos rotulos do minimapa.

O OTBM guarda, num no proprio, o nome e a posicao do templo de cada cidade.
E a unica fonte de nomes que o mapa tem: rotas, cavernas e pontos de
interesse nao ficam ali -- num servidor como o PXG esses sao cadastrados a
mao. Aqui aproveitamos o que ja existe, de graca.

Uso:
    python gen_towns.py <map.otbm> <saida.lua>
"""
import struct
import sys

NODE_START, NODE_END, ESCAPE = 0xFE, 0xFF, 0xFD
OTBM_TOWNS, OTBM_TOWN = 12, 13


def parse_towns(path):
    data = open(path, 'rb').read()
    n = len(data)
    towns = []
    i = 4

    while i < n:
        if data[i] != NODE_START:
            i += 1
            continue
        i += 1
        node_type = data[i]
        i += 1

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

        if node_type != OTBM_TOWN or len(props) < 11:
            continue

        # u32 id, u16 tamanho do nome, nome, u16 x, u16 y, u8 z
        try:
            town_id = struct.unpack_from('<I', props, 0)[0]
            name_len = struct.unpack_from('<H', props, 4)[0]
            if 6 + name_len + 5 > len(props):
                continue
            name = props[6:6 + name_len].decode('latin-1')
            p = 6 + name_len
            x, y = struct.unpack_from('<HH', props, p)
            z = props[p + 4]
        except (struct.error, IndexError):
            continue

        if name.strip() and 0 < x < 65535 and 0 < y < 65535:
            towns.append((town_id, name.strip(), x, y, z))

    return towns


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    towns = parse_towns(sys.argv[1])
    towns.sort(key=lambda t: t[1].lower())

    lines = [
        '-- Gerado por design/gen_towns.py a partir do PGalaxy.otbm.',
        '-- Nao editar a mao: rode o script de novo se o mapa mudar.',
        '-- Para acrescentar pontos que o mapa nao tem (rotas, cavernas),',
        '-- use minimapExtraLabels em minimap.lua.',
        'MinimapTowns = {',
    ]
    for _tid, name, x, y, z in towns:
        safe = name.replace('\\', '\\\\').replace('"', '\\"')
        lines.append('  { name = "%s", x = %d, y = %d, z = %d },' % (safe, x, y, z))
    lines.append('}')
    lines.append('')

    open(sys.argv[2], 'wb').write('\n'.join(lines).encode('latin-1'))
    print('%d cidades encontradas' % len(towns))
    for _tid, name, x, y, z in towns[:12]:
        print('  %-28s (%d, %d, %d)' % (name, x, y, z))
    if len(towns) > 12:
        print('  ... e mais %d' % (len(towns) - 12))
    return 0


if __name__ == '__main__':
    sys.exit(main())
