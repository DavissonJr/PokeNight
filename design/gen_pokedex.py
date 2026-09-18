# -*- coding: utf-8 -*-
"""Extrai a pokedex do servidor para a tabela que o cliente desenha.

A fonte e a tabela newpokedex de datapack/lib/configuration.lua:

  ["Bulbasaur"] = {gender = 875, level = 18, storage = 1001, stoCatch = 666001},

Duas coisas saem dali:
  - o numero da pokedex, de storage - 1000 (Bulbasaur, storage 1001, e o #1);
  - o stoCatch, storage que o servidor marca ao capturar.

So a faixa 1001-1999 e pokedex numerada. As demais (10000, 11000, 14000...)
sao shinies e variantes, que existem no jogo mas nao ocupam posicao --
aplicar storage - 1000 nelas produzia numeros absurdos como #113754.

Uso:
    python gen_pokedex.py <configuration.lua> <saida.lua>
"""
import re
import sys

RE_ENTRY = re.compile(
    r'\["([^"]+)"\]\s*=\s*\{[^}]*?storage\s*=\s*(\d+)[^}]*?stoCatch\s*=\s*(\d+)[^}]*?\}')

DEX_BASE = 1000


def lua_escape(name):
    return name.replace('\\', '\\\\').replace('"', '\\"')


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1

    data = open(sys.argv[1], 'rb').read().decode('latin-1')

    # oldpokedex vem depois e tem outra numeracao: para antes dela.
    start = data.find('newpokedex = {')
    if start < 0:
        print('newpokedex nao encontrada')
        return 1
    end = data.find('oldpokedex', start)
    block = data[start:end if end > 0 else len(data)]

    numbered = []
    extras = []
    for m in RE_ENTRY.finditer(block):
        name, storage, sto_catch = m.group(1), int(m.group(2)), int(m.group(3))
        if DEX_BASE < storage < DEX_BASE + 1000:
            numbered.append((storage - DEX_BASE, name, sto_catch))
        else:
            extras.append((name, sto_catch))

    # Numero repetido significa entrada duplicada no lua; fica a primeira.
    seen = set()
    unique = []
    for number, name, sto in sorted(numbered):
        if number in seen:
            continue
        seen.add(number)
        unique.append((number, name, sto))

    out = []
    out.append('-- Gerado por design/gen_pokedex.py a partir de newpokedex, em')
    out.append('-- datapack/lib/configuration.lua. Nao editar a mao.')
    out.append('--')
    out.append('-- number: posicao na pokedex (storage - 1000)')
    out.append('-- catch:  storage que o servidor marca ao capturar')
    out.append('PokedexList = {')
    for number, name, sto in unique:
        out.append('  { number = %d, name = "%s", catch = %d },'
                   % (number, lua_escape(name), sto))
    out.append('}')
    out.append('')
    out.append('-- Shinies e variantes: existem e podem ser capturados, mas nao')
    out.append('-- ocupam posicao na numeracao da pokedex.')
    out.append('PokedexExtras = {')
    for name, sto in sorted(extras, key=lambda x: x[0].lower()):
        out.append('  { name = "%s", catch = %d },' % (lua_escape(name), sto))
    out.append('}')
    out.append('')

    open(sys.argv[2], 'wb').write('\n'.join(out).encode('latin-1'))
    print('%d na pokedex numerada, %d extras (shiny/variantes)'
          % (len(unique), len(extras)))
    for number, name, sto in unique[:4]:
        print('  #%-4d %-16s catch %d' % (number, name, sto))
    if unique:
        print('  ...  ultimo numerado: #%d %s' % (unique[-1][0], unique[-1][1]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
