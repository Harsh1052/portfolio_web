#!/usr/bin/env python3
"""
Run after placing images:
  web/icons/hs_logo.png  — the HS monogram logo (any size ≥ 512px)
  web/preview.png         — the OG preview card (1200×630)

Usage:
  python3 scripts/update_icons.py
"""

import sys
from pathlib import Path
from PIL import Image

repo = Path(__file__).parent.parent
web  = repo / "web"
icons = web / "icons"

LOGO_SRC   = icons / "hs_logo.png"
OG_SRC     = web / "preview.png"

ICON_SIZES = {
    icons / "Icon-192.png":         (192, 192),
    icons / "Icon-512.png":         (512, 512),
    icons / "Icon-maskable-192.png": (192, 192),
    icons / "Icon-maskable-512.png": (512, 512),
    web / "favicon.png":            (32, 32),
}

def check(path, label):
    if not path.exists():
        print(f"✗ Missing: {path.relative_to(repo)} — {label}")
        return False
    return True

ok = check(LOGO_SRC, "HS logo PNG") & check(OG_SRC, "OG preview PNG")
if not ok:
    sys.exit(1)

logo = Image.open(LOGO_SRC).convert("RGBA")
for dest, size in ICON_SIZES.items():
    resized = logo.resize(size, Image.LANCZOS)
    # Flatten onto white for non-transparent formats
    if dest.suffix == ".png":
        resized.save(dest, "PNG")
    print(f"✓ {dest.relative_to(repo)}  ({size[0]}×{size[1]})")

print("\nAll icons updated. Run to redeploy:")
print("  fvm flutter build web --release && firebase deploy --only hosting")
