# -*- coding: utf-8 -*-
"""Icone do cofre para a barra superior (46x46, como os demais).

Geometria pura: corpo, porta, disco e manopla. Desenhado em 4x e reduzido,
que e como se consegue borda limpa nesse tamanho.
"""
from PIL import Image, ImageDraw
import os

SS = 4
SIZE = 46
ACCENT = (255, 122, 24)
ACCENT_HI = (255, 162, 77)
DARK = (20, 20, 22)
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   '..', 'Myst', 'Cliente Descriptografado', 'data', 'images', 'topbuttons')

S = SIZE * SS
im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
d = ImageDraw.Draw(im)

pad = 5 * SS
ring = 3 * SS

# corpo do cofre
d.rounded_rectangle([pad, pad, S - pad, S - pad], radius=5 * SS,
                    fill=DARK + (255,), outline=ACCENT + (255,), width=ring)

# porta
ipad = pad + 4 * SS
d.rounded_rectangle([ipad, ipad, S - ipad, S - ipad], radius=3 * SS,
                    outline=ACCENT + (180,), width=max(2 * SS // 2, SS))

# disco central
cx = cy = S // 2
r = int(S * 0.13)
d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=ACCENT + (255,), width=ring)
rr = r // 2
d.ellipse([cx - rr, cy - rr, cx + rr, cy + rr], fill=ACCENT_HI + (255,))

# manopla: dois tracos saindo do disco
d.line([(cx + r, cy), (cx + r + 3 * SS, cy)], fill=ACCENT + (255,), width=ring)
d.line([(cx, cy - r), (cx, cy - r - 3 * SS)], fill=ACCENT + (255,), width=ring)

im.resize((SIZE, SIZE), Image.LANCZOS).save(os.path.join(OUT, 'bank.png'))
print('gerado bank.png 46x46')
