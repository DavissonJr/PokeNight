# -*- coding: utf-8 -*-
"""Gera a tabela nome de pokemon -> outfit, usada na selecao de personagem.

A lista de personagens que o servidor manda nao inclui o time; ele vem da
API (api/index.php, rota characters), que le as pokebolas na mochila. Mas a
API devolve so o NOME de cada pokemon -- para desenha-lo o cliente precisa
do looktype, que so existe nos XMLs de monstro do servidor.

Uso:
    python gen_poke_looktypes.py <pasta monster/> <saida.lua>
"""
import os
import re
import sys

RE_NAME = re.compile(rb'<monster\s+name="([^"]+)"', re.I)
RE_LOOK = re.compile(
    rb'<look\s+type="(\d+)"'
    rb'(?:[^>]*?head="(\d+)")?'
    rb'(?:[^>]*?body="(\d+)")?'
    rb'(?:[^>]*?legs="(\d+)")?'
    rb'(?:[^>]*?feet="(\d+)")?',
    re.I)


def collect(root):
    found = {}
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.lower().endswith('.xml'):
                continue
            path = os.path.join(dirpath, fn)
            try:
                data = open(path, 'rb').read()
            except OSError:
                continue

            m_name = RE_NAME.search(data)
            m_look = RE_LOOK.search(data)
            if not m_name or not m_look:
                continue

            name = m_name.group(1).decode('latin-1').strip()
            look = int(m_look.group(1))
            if look <= 0 or not name:
                continue

            def g(i):
                v = m_look.group(i)
                return int(v) if v else 0

            # Mesmo nome em varias pastas (geracoes, bosses): o primeiro
            # que aparecer serve -- o outfit e o mesmo.
            if name not in found:
                found[name] = (look, g(2), g(3), g(4), g(5))
    return found


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    found = collect(sys.argv[1])

    lines = [
        '-- Gerado por design/gen_poke_looktypes.py a partir dos XMLs de',
        '-- monstro do servidor. Nao editar a mao.',
        'PokeLooktypes = {',
    ]
    for name in sorted(found, key=lambda s: s.lower()):
        look, head, body, legs, feet = found[name]
        safe = name.replace('\\', '\\\\').replace('"', '\\"')
        lines.append('  ["%s"] = { type = %d, head = %d, body = %d, legs = %d, feet = %d },'
                     % (safe, look, head, body, legs, feet))
    lines.append('}')
    lines.append('')

    open(sys.argv[2], 'wb').write('\n'.join(lines).encode('latin-1'))
    print('%d pokemons mapeados' % len(found))
    for name in sorted(found, key=lambda s: s.lower())[:6]:
        print('  %-18s look %d' % (name, found[name][0]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
