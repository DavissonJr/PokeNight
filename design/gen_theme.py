# -*- coding: utf-8 -*-
"""Gerador do tema PokeOrigin (PKO) para OTClient.

As sprites do OTClient sao folhas 9-slice: um bloco por estado, empilhados
na vertical. O .otui recorta cada estado com image-clip e estica as bordas
com image-border. Por isso cada peca aqui e gerada na medida EXATA da
original -- trocar a medida quebraria o layout de todas as telas.

Tudo e desenhado em 4x e reduzido no final (supersampling), que e como se
consegue canto arredondado limpo em peca de 20px.
"""
from PIL import Image, ImageDraw
import os

SS = 4  # fator de supersampling
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pko-theme')
os.makedirs(OUT, exist_ok=True)

# ---- Paleta PokeOrigin (preto + laranja) -----------------------------------
BG        = (10, 10, 11)       # preto de fundo
SURF      = (20, 20, 22)       # superficie padrao
SURF_HI   = (31, 31, 34)       # superficie elevada / hover
SURF_LO   = (14, 14, 16)       # superficie afundada / pressed
BORDER    = (42, 42, 46)       # borda padrao
BORDER_HI = (61, 61, 68)       # borda destacada
ACCENT    = (255, 122, 24)     # laranja de acao
ACCENT_HI = (255, 162, 77)     # laranja claro (brilho)
TEXT_DIM  = (138, 138, 146)

def rr(draw, box, radius, fill=None, outline=None, width=1):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)

def cell(w, h, radius, fill, border, top_glow=None, inset=False):
    """Desenha um estado (uma celula da folha) com supersampling."""
    im = Image.new('RGBA', (w*SS, h*SS), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    r = radius*SS
    rr(d, [0, 0, w*SS-1, h*SS-1], r, fill=fill+(255,), outline=border+(255,), width=SS)
    if top_glow:
        # linha superior mais clara: da volume sem precisar de gradiente
        d.line([(r, SS//2), (w*SS-r, SS//2)], fill=top_glow+(255,), width=SS)
    if inset:
        d.line([(r, h*SS-SS), (w*SS-r, h*SS-SS)], fill=BORDER_HI+(120,), width=SS)
    return im.resize((w, h), Image.LANCZOS)

def sheet(path, w, h_cell, states):
    """Empilha os estados numa folha vertical e salva."""
    im = Image.new('RGBA', (w, h_cell*len(states)), (0, 0, 0, 0))
    for i, st in enumerate(states):
        im.paste(st, (0, i*h_cell), st)
    im.save(os.path.join(OUT, path))
    return im

# ---- button.png / button_rounded.png  (20x60 = 3 estados de 20x20) --------
btn = [
    cell(20, 20, 4, SURF,    BORDER,    top_glow=BORDER_HI),   # normal
    cell(20, 20, 4, SURF_HI, ACCENT,    top_glow=ACCENT),      # hover
    cell(20, 20, 4, SURF_LO, BORDER_HI, inset=True),           # pressed
]
sheet('button.png', 20, 20, btn)
sheet('button_rounded.png', 20, 20, btn)

# ---- tabbutton_rounded.png (20x60) ---------------------------------------
# Aba inativa e mais apagada; a ativa ganha a borda de acento.
tab = [
    cell(20, 20, 4, SURF_LO, BORDER,    top_glow=None),
    cell(20, 20, 4, SURF_HI, BORDER_HI, top_glow=BORDER_HI),
    cell(20, 20, 4, SURF,    ACCENT,    top_glow=ACCENT),
]
sheet('tabbutton_rounded.png', 20, 20, tab)

# ---- panel_flat.png (32x32, peca unica) ----------------------------------
cell(32, 32, 5, SURF, BORDER, top_glow=BORDER_HI).save(os.path.join(OUT, 'panel_flat.png'))

# ---- textedit.png (32x32) -------------------------------------------------
cell(32, 32, 4, SURF_LO, BORDER, inset=True).save(os.path.join(OUT, 'textedit.png'))

# ---- progressbar.png (80x16 = 2 estados de 80x8) -------------------------
pb = Image.new('RGBA', (80, 16), (0, 0, 0, 0))
trilho = cell(80, 8, 3, SURF_LO, BORDER)
preench = cell(80, 8, 3, ACCENT, ACCENT, top_glow=ACCENT_HI)
pb.paste(trilho, (0, 0), trilho)
pb.paste(preench, (0, 8), preench)
pb.save(os.path.join(OUT, 'progressbar.png'))

print('gerado em', OUT)
for f in sorted(os.listdir(OUT)):
    im = Image.open(os.path.join(OUT, f))
    print(f'  {im.size[0]:>3}x{im.size[1]:<4} {f}')
