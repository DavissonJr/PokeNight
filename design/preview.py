# -*- coding: utf-8 -*-
"""Renderiza um mock da UI usando as sprites geradas, com 9-slice de verdade,
para mostrar como as pecas se comportam esticadas -- que e como o OTClient
as usa. Comparar sprite crua nao diz nada; esticada diz tudo."""
from PIL import Image, ImageDraw, ImageFont
import os

SP  = os.path.dirname(os.path.abspath(__file__))
TH  = os.path.join(SP, 'pko-theme')

def nine_slice(src, w, h, b):
    """Estica src para (w,h) preservando cantos de b px -- igual image-border."""
    sw, sh = src.size
    out = Image.new('RGBA', (w, h), (0,0,0,0))
    def part(l, t, r, bo): return src.crop((l, t, r, bo))
    # cantos
    out.paste(part(0,0,b,b), (0,0))
    out.paste(part(sw-b,0,sw,b), (w-b,0))
    out.paste(part(0,sh-b,b,sh), (0,h-b))
    out.paste(part(sw-b,sh-b,sw,sh), (w-b,h-b))
    # bordas
    top = part(b,0,sw-b,b).resize((w-2*b, b), Image.NEAREST)
    bot = part(b,sh-b,sw-b,sh).resize((w-2*b, b), Image.NEAREST)
    lef = part(0,b,b,sh-b).resize((b, h-2*b), Image.NEAREST)
    rig = part(sw-b,b,sw,sh-b).resize((b, h-2*b), Image.NEAREST)
    out.paste(top,(b,0)); out.paste(bot,(b,h-b))
    out.paste(lef,(0,b)); out.paste(rig,(w-b,b))
    # miolo
    mid = part(b,b,sw-b,sh-b).resize((w-2*b, h-2*b), Image.NEAREST)
    out.paste(mid,(b,b))
    return out

def state(path, idx, cell_h):
    im = Image.open(os.path.join(TH, path)).convert('RGBA')
    return im.crop((0, idx*cell_h, im.size[0], (idx+1)*cell_h))

W, H = 760, 420
canvas = Image.new('RGBA', (W, H), (8, 12, 22, 255))
d = ImageDraw.Draw(canvas)

try:
    f  = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 14)
    fb = ImageFont.truetype("C:/Windows/Fonts/segoeuib.ttf", 16)
    fs = ImageFont.truetype("C:/Windows/Fonts/segoeui.ttf", 11)
except Exception:
    f = fb = fs = ImageFont.load_default()

TXT = (232, 238, 247); DIM = (138, 154, 176)
d.text((24, 20), "PokeOrigin — tema proposto", font=fb, fill=TXT)
d.text((24, 42), "pecas 9-slice esticadas, como o cliente as usa", font=fs, fill=DIM)

# painel grande
panel = nine_slice(Image.open(os.path.join(TH,'panel_flat.png')).convert('RGBA'), 330, 250, 6)
canvas.paste(panel, (24, 72), panel)
d.text((44, 90), "Painel", font=f, fill=TXT)

# botoes nos tres estados
for i, (lbl, y) in enumerate([("normal", 124), ("hover", 166), ("pressed", 208)]):
    b = nine_slice(state('button.png', i, 20), 150, 30, 4)
    canvas.paste(b, (44, y), b)
    d.text((100, y+8), lbl, font=f, fill=TXT if i != 0 else DIM)

# campo de texto
te = nine_slice(Image.open(os.path.join(TH,'textedit.png')).convert('RGBA'), 270, 30, 5)
canvas.paste(te, (44, 254), te)
d.text((54, 262), "campo de busca", font=f, fill=DIM)

# barra de progresso (trilho + preenchimento 62%)
tr = nine_slice(state('progressbar.png', 0, 8), 270, 14, 3)
canvas.paste(tr, (44, 296), tr)
fi = nine_slice(state('progressbar.png', 1, 8), int(270*0.62), 14, 3)
canvas.paste(fi, (44, 296), fi)
d.text((44, 316), "HP  62%", font=fs, fill=DIM)

# abas
for i, (lbl, st) in enumerate([("Pokemon", 2), ("Bag", 0), ("Mapa", 0)]):
    t = nine_slice(state('tabbutton_rounded.png', st, 20), 96, 28, 4)
    canvas.paste(t, (400 + i*104, 90), t)
    d.text((400 + i*104 + 16, 97), lbl, font=f, fill=TXT if st == 2 else DIM)

# painel lateral com "slots"
side = nine_slice(Image.open(os.path.join(TH,'panel_flat.png')).convert('RGBA'), 312, 190, 6)
canvas.paste(side, (400, 132), side)
for i in range(6):
    sx, sy = 416 + (i % 3)*98, 150 + (i // 3)*88
    slot = nine_slice(state('button.png', 0, 20), 88, 78, 4)
    canvas.paste(slot, (sx, sy), slot)
    d.text((sx+10, sy+30), f"slot {i+1}", font=fs, fill=DIM)

canvas.convert('RGB').save(os.path.join(SP, 'pko-preview.png'))
print("preview salvo:", os.path.join(SP, 'pko-preview.png'))
