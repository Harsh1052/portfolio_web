#!/usr/bin/env python3
"""v2 art pipeline — SVG hero illustrations → grained PNG/WebP layers.

Reproduces the Wonderous texture recipe: flat-shape vector art rasterized,
then finished with a subtle speckle grain clipped to the artwork's alpha.

Usage:
    pip install cairosvg pillow
    python scripts/generate_v2_art.py assets/v2/valley/valley_hero.svg

Outputs, next to the input file:
    <name>.png            1x, grained
    2.0x/<name>.png       2x, grained
    <name>_flat.png       1x, un-grained (debugging)
"""

import pathlib
import random
import sys

import cairosvg
from PIL import Image, ImageDraw

GRAIN_SEED = 7
DARK_GRAIN = (60, 30, 10)
LIGHT_GRAIN = (255, 245, 220)


def apply_grain(img: Image.Image, density: float = 0.043) -> Image.Image:
    """Speckle grain clipped to the artwork's alpha, Wonderous-style."""
    w, h = img.size
    rng = random.Random(GRAIN_SEED)
    speck = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(speck)

    for _ in range(int(w * h * density)):
        x, y = rng.randint(0, w - 1), rng.randint(0, h - 1)
        if rng.random() < 0.5:
            d.point((x, y), fill=(*DARK_GRAIN, rng.randint(8, 26)))
        else:
            d.point((x, y), fill=(*LIGHT_GRAIN, rng.randint(8, 22)))

    for _ in range(int(w * h * 0.002)):
        x, y = rng.randint(0, w - 3), rng.randint(0, h - 3)
        d.ellipse((x, y, x + 2, y + 2), fill=(*DARK_GRAIN, rng.randint(6, 14)))

    mask = img.split()[3].point(lambda p: 255 if p > 10 else 0)
    speck.putalpha(Image.composite(speck.split()[3], Image.new('L', (w, h), 0), mask))
    return Image.alpha_composite(img, speck)


def build(svg_path: pathlib.Path) -> None:
    name = svg_path.stem
    out_dir = svg_path.parent

    for scale, sub in [(1, ''), (2, '2.0x')]:
        flat_bytes = cairosvg.svg2png(url=str(svg_path), scale=scale)
        tmp = out_dir / f'{name}_tmp.png'
        tmp.write_bytes(flat_bytes)
        img = Image.open(tmp).convert('RGBA')
        tmp.unlink()

        if scale == 1:
            img.save(out_dir / f'{name}_flat.png')

        target = out_dir / sub if sub else out_dir
        target.mkdir(exist_ok=True)
        apply_grain(img).save(target / f'{name}.png')
        print(f'  {target / f"{name}.png"} ({img.size[0]}x{img.size[1]})')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for arg in sys.argv[1:]:
        print(f'building {arg}')
        build(pathlib.Path(arg))
