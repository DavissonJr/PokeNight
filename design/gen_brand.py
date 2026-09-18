# -*- coding: utf-8 -*-
"""Identidade visual do PokeOrigin: marca, wordmark e fundo da tela de login.

Tudo geometrico e gerado em 4x para reduzir depois (supersampling), que e
o que da borda limpa sem depender de arte rasterizada.
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

SS  = 4
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'pko-brand')
os.makedirs(OUT, exist_ok=True)

BG        = (10, 10, 11)
SURF      = (20, 20, 22)
ACCENT    = (255, 122, 24)
ACCENT_HI = (255, 162, 77)
WHITE     = (245, 245, 246)
DIM       = (138, 138, 146)

def font(px, bold=False):
    for p in (["C:/Windows/Fonts/segoeuib.ttf", "C:/Windows/Fonts/seguisb.ttf"] if bold
              else ["C:/Windows/Fonts/segoeui.ttf"]):
        try:
            return ImageFont.truetype(p, px)
        except Exception:
            pass
    return ImageFont.load_default()

def mark(size):
    """Pokebola: hemisferio superior solido, inferior vazado, banda e botao.
    O anel totalmente vazado lia como volante -- preencher o topo e o que
    torna a silhueta inconfundivel."""
    S = size*SS
    im = Image.new('RGBA', (S, S), (0,0,0,0))
    d  = ImageDraw.Draw(im)
    ring = max(3*SS, S//11)
    pad  = ring//2
    box  = [pad, pad, S-1-pad, S-1-pad]

    # hemisferio superior solido
    top = Image.new('RGBA', (S, S), (0,0,0,0))
    td = ImageDraw.Draw(top)
    td.ellipse(box, fill=ACCENT+(255,))
    cut = Image.new('L', (S, S), 255)
    ImageDraw.Draw(cut).rectangle([0, S//2, S, S], fill=0)
    im.paste(top, (0, 0), cut)

    # anel externo fecha a silhueta
    d.ellipse(box, outline=ACCENT+(255,), width=ring)

    # banda separando as metades
    d.rectangle([pad, S//2 - ring//2, S-1-pad, S//2 + ring//2], fill=ACCENT+(255,))

    # botao central
    r = int(S*0.17)
    cx = cy = S//2
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=BG+(255,))
    d.ellipse([cx-r, cy-r, cx+r, cy+r], outline=ACCENT+(255,), width=ring)
    rr = int(r*0.42)
    d.ellipse([cx-rr, cy-rr, cx+rr, cy+rr], fill=ACCENT_HI+(255,))
    return im.resize((size, size), Image.LANCZOS)

# ---- marca isolada (favicon / canto da tela) ------------------------------
for s in (64, 128, 256):
    mark(s).save(os.path.join(OUT, f'mark_{s}.png'))

# ---- wordmark: marca + "PokeOrigin" + tagline ----------------------------
W, H = 520, 120
wm = Image.new('RGBA', (W, H), (0,0,0,0))
m = mark(88)
wm.paste(m, (0, 12), m)
d = ImageDraw.Draw(wm)
f1 = font(46, bold=True)
f2 = font(15)
d.text((104, 24), "Poke", font=f1, fill=WHITE)
w_poke = d.textlength("Poke", font=f1)
d.text((104 + w_poke, 24), "Origin", font=f1, fill=ACCENT)
d.text((108, 78), "P  K  O   ·   P O K E M O N   O N L I N E", font=f2, fill=DIM)
wm.save(os.path.join(OUT, 'wordmark.png'))
chk = Image.new('RGB', (W, H), BG)
chk.paste(wm, (0, 0), wm)
chk.save(os.path.join(OUT, 'wordmark_on_dark.png'))

# ---- fundo da tela de login ----------------------------------------------
# Gradiente radial escuro + brilho laranja no canto, sem textura ruidosa.
BW, BH = 1280, 720
bg = Image.new('RGB', (BW, BH), BG)
glow = Image.new('RGB', (BW, BH), BG)
gd = ImageDraw.Draw(glow)
gd.ellipse([-260, -320, 720, 480], fill=(70, 32, 8))
gd.ellipse([BW-520, BH-380, BW+260, BH+200], fill=(44, 22, 8))
glow = glow.filter(ImageFilter.GaussianBlur(190))
bg = Image.blend(bg, glow, 0.85)
d = ImageDraw.Draw(bg)
# grade tenue: da textura "tecnologica" sem poluir
for x in range(0, BW, 48):
    d.line([(x, 0), (x, BH)], fill=(17, 17, 19), width=1)
for y in range(0, BH, 48):
    d.line([(0, y), (BW, y)], fill=(17, 17, 19), width=1)
bg.save(os.path.join(OUT, 'login_bg.png'))

# ---- wordmark somente texto (a marca aparece separada na tela) -----------
TW, TH = 300, 78
tw = Image.new('RGBA', (TW, TH), (0,0,0,0))
d = ImageDraw.Draw(tw)
f1 = font(44, bold=True)
f2 = font(13)
d.text((0, 2), "Poke", font=f1, fill=WHITE)
wp = d.textlength("Poke", font=f1)
d.text((wp, 2), "Origin", font=f1, fill=ACCENT)
d.text((3, 56), "P  K  O   ·   P O K E M O N   O N L I N E", font=f2, fill=DIM)
tw.save(os.path.join(OUT, 'wordmark_text.png'))

print('gerado em', OUT)
for f in sorted(os.listdir(OUT)):
    im = Image.open(os.path.join(OUT, f))
    print(f'  {im.size[0]:>4}x{im.size[1]:<4} {f}')
