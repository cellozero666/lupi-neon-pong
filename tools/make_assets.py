import os
import struct
import zlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMG = os.path.join(ROOT, "img")
os.makedirs(IMG, exist_ok=True)

def png_chunk(tag, data):
    return (struct.pack(">I", len(data)) + tag + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF))

def write_png(path, w, h, getpx):
    rows = b""
    for y in range(h):
        row = b"\x00"
        for x in range(w):
            r, g, b, a = getpx(x, y)
            row += bytes((r, g, b, a))
        rows += row
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    data = (png_chunk(b"IHDR", ihdr)
            + png_chunk(b"IDAT", zlib.compress(rows))
            + png_chunk(b"IEND", b""))
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n" + data)

WHITE = (255, 255, 255)
MAGENTA = (255, 0, 255)
GREEN = (0, 255, 0)
GRAY = (150, 150, 150)
P1_DARK = (150, 0, 150)
P2_DARK = (0, 110, 0)
TRANSPARENT = (0, 0, 0, 0)

def opaque(rgb):
    return (rgb[0], rgb[1], rgb[2], 255)

# palette swatches: pins the exact color set (first-seen order)
write_png(
    os.path.join(IMG, "palette.png"),
    6, 1,
    lambda x, y: opaque([WHITE, MAGENTA, P1_DARK, GREEN, P2_DARK, GRAY][x]),
)

# ball: 8x8 white circle with transparent corners
def ball_px(x, y):
    dx, dy = x - 3.5, y - 3.5
    if dx * dx + dy * dy <= 12.25:
        return opaque(WHITE)
    return TRANSPARENT

write_png(os.path.join(IMG, "ball.png"), 8, 8, ball_px)

# paddles: 12x48 filled body with 1px darker border
def paddle_px(body, edge):
    def px(x, y):
        if x == 0 or y == 0 or x == 11 or y == 47:
            return opaque(edge)
        return opaque(body)
    return px

write_png(os.path.join(IMG, "paddle_p1.png"), 12, 48, paddle_px(MAGENTA, P1_DARK))
write_png(os.path.join(IMG, "paddle_p2.png"), 12, 48, paddle_px(GREEN, P2_DARK))

print("assets written to", IMG)