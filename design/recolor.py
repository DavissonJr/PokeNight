# -*- coding: utf-8 -*-
"""Recoloriza o tema do cliente de azul para preto+laranja (PokeOrigin).

Por que recolorir em vez de redesenhar: as sprites existentes ja carregam
sombreado, bordas e a estrutura 9-slice correta. Regerar 141 pecas do zero
perderia esse trabalho e arriscaria quebrar layout. Aqui so a cor muda --
forma, tamanho e alfa ficam intactos.

Regra, aplicada em HSV:
  - cinzas (saturacao baixa)      -> preservados, sao neutros de propósito
  - azuis escuros  (V < LIMIAR)   -> quase-neutros escuros: viram a
                                     superficie preta do tema
  - azuis claros/saturados        -> laranja: sao os acentos da interface
  - dourados/amarelos             -> laranja, pela mesma razao

Uso:
    python recolor.py <pasta> [--apply]
Sem --apply ele so relata o que faria.
"""
import colorsys
import os
import sys

from PIL import Image

# Matiz alvo do PokeOrigin: laranja #ff7a18 (~25 graus).
TARGET_HUE = 25.0 / 360.0

# Faixas de matiz consideradas "azul" e "dourado" no tema original.
BLUE_RANGE = (165.0 / 360.0, 275.0 / 360.0)
GOLD_RANGE = (35.0 / 360.0, 62.0 / 360.0)

# Abaixo deste brilho o pixel e superficie (fundo), nao acento.
# Limiar alto de proposito: no tema original o azul claro e saturado E a
# superficie, nao um destaque. Com limiar baixo essas areas viravam laranja
# lavado (marrom) em vez do preto que o tema pede.
SURFACE_V = 0.52
# Abaixo desta saturacao o pixel ja e neutro: nao se mexe.
NEUTRAL_S = 0.12


def convert_pixel(r, g, b):
    h, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)

    if s < NEUTRAL_S:
        return r, g, b  # cinza/preto/branco: preservado

    in_blue = BLUE_RANGE[0] <= h <= BLUE_RANGE[1]
    in_gold = GOLD_RANGE[0] <= h <= GOLD_RANGE[1]
    if not (in_blue or in_gold):
        return r, g, b  # vermelho de vida, verde de mana etc. ficam

    if v < SURFACE_V:
        # Superficie: vira preto levemente quente, nao azul escuro.
        ns = s * 0.08
        nv = v * 0.55
    else:
        # Acento: laranja vivo. Forcamos um piso de saturacao porque azul
        # pouco saturado converteria para um laranja acinzentado.
        ns = min(1.0, max(s, 0.78))
        nv = min(1.0, v * 1.12)

    nr, ng, nb = colorsys.hsv_to_rgb(TARGET_HUE, ns, nv)
    return int(nr * 255), int(ng * 255), int(nb * 255)


def convert_image(path, apply_changes):
    im = Image.open(path)
    had_alpha = im.mode in ('RGBA', 'LA') or 'transparency' in im.info
    im = im.convert('RGBA')
    px = im.load()
    w, h = im.size

    cache = {}
    changed = 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            key = (r, g, b)
            if key not in cache:
                cache[key] = convert_pixel(r, g, b)
            nr, ng, nb = cache[key]
            if (nr, ng, nb) != key:
                px[x, y] = (nr, ng, nb, a)
                changed += 1

    if apply_changes and changed:
        # Mantem RGB quando o original nao tinha alfa, para nao inflar o arquivo
        # nem mudar como o cliente interpreta a sprite.
        im.save(path) if had_alpha else im.convert('RGB').save(path)
    return changed, w * h


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    folder = sys.argv[1]
    apply_changes = '--apply' in sys.argv

    files = sorted(f for f in os.listdir(folder) if f.lower().endswith('.png'))
    total_changed = total_files = 0
    skipped = []
    for f in files:
        try:
            changed, size = convert_image(os.path.join(folder, f), apply_changes)
        except (PermissionError, OSError) as exc:
            # Arquivo que o OneDrive ainda nao materializou localmente: le,
            # mas nao deixa gravar. Um desses nao pode travar o lote inteiro.
            skipped.append((f, type(exc).__name__))
            continue
        if changed:
            total_files += 1
            total_changed += changed

    verb = 'recoloridos' if apply_changes else 'seriam recoloridos'
    print('%d de %d arquivos %s (%d pixels)' % (total_files, len(files), verb, total_changed))
    if skipped:
        print('  NAO gravados (%d): %s' % (len(skipped), ', '.join(n for n, _ in skipped)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
