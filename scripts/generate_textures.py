#!/usr/bin/env python3
"""Generates the tileable speckle grain texture for v2 scenes.

White speckles at varying alpha on a transparent canvas — designed to be
tinted at runtime via `IllustrationTexture(color: ...)`, exactly like
Wonderous's `speckles-white.png`.

Usage:
    pip install pillow
    python scripts/generate_textures.py
"""

import pathlib
import random

from PIL import Image, ImageDraw

OUT = pathlib.Path(__file__).resolve().parent.parent / 'assets/v2/_common'
SEED = 42


def speckles(size: int) -> Image.Image:
    rng = random.Random(SEED)
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Fine grain
    for _ in range(int(size * size * 0.045)):
        x, y = rng.randint(0, size - 1), rng.randint(0, size - 1)
        d.point((x, y), fill=(255, 255, 255, rng.randint(10, 34)))

    # Occasional larger flecks
    for _ in range(int(size * size * 0.0022)):
        x, y = rng.randint(0, size - 3), rng.randint(0, size - 3)
        r = rng.choice([1, 1, 2])
        d.ellipse((x, y, x + r, y + r), fill=(255, 255, 255, rng.randint(8, 20)))

    return img


if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    speckles(256).save(OUT / 'speckles.png')
    (OUT / '2.0x').mkdir(exist_ok=True)
    speckles(512).save(OUT / '2.0x' / 'speckles.png')
    print(f'wrote {OUT}/speckles.png (256) and 2.0x/speckles.png (512)')
