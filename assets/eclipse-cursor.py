from pathlib import Path
import shutil
import zipfile
import re
import struct

ROOT = Path.home() / ".local/share/icons"
SRC = ROOT / "Bibata-Modern-Ice"
DST = ROOT / "Eclipse-Dark"

DARK = "#101018"
PINK = "#CF7894"

if not SRC.is_dir():
    raise SystemExit("Original theme not found")

if DST.exists():
    raise SystemExit("Eclipse-Dark already exists")

shutil.copytree(SRC, DST)

# Recolor Hyprcursor SVG files
for path in (DST / "hyprcursors").glob("*.hlc"):
    with zipfile.ZipFile(path, "r") as archive:
        entries = [
            (info, archive.read(info))
            for info in archive.infolist()
        ]

    with zipfile.ZipFile(path, "w") as archive:
        for info, data in entries:
            if info.filename.endswith(".svg"):
                svg = data.decode("utf-8")
                svg = re.sub(
                    r"#(?:ffffff|fff)\b",
                    DARK, svg, flags=re.I
                )
                svg = re.sub(
                    r"#(?:000000|000)\b",
                    PINK, svg, flags=re.I
                )
                data = svg.encode("utf-8")

            archive.writestr(info, data)

# Recolor XCursor images
for path in (DST / "cursors").iterdir():
    if not path.is_file():
        continue

    data = bytearray(path.read_bytes())

    if data[:4] != b"Xcur":
        continue

    header, version, ntoc = struct.unpack_from(
        "<III", data, 4
    )

    processed = set()

    for i in range(ntoc):
        kind, subtype, pos = struct.unpack_from(
            "<III", data, header + i * 12
        )

        if kind != 0xfffd0002 or pos in processed:
            continue

        processed.add(pos)

        h, t, s, v, w, height, x, y, delay = (
            struct.unpack_from("<9I", data, pos)
        )

        start = pos + h

        for p in range(start, start + w * height * 4, 4):
            b, g, r, a = data[p:p+4]

            if a == 0:
                continue

            light = min(1, (r + g + b) / (3 * a))

            nr = round((207 + (16 - 207) * light) * a / 255)
            ng = round((120 + (16 - 120) * light) * a / 255)
            nb = round((148 + (24 - 148) * light) * a / 255)

            data[p:p+4] = bytes((nb, ng, nr, a))

    path.write_bytes(data)

# Rename theme metadata
for name in ("manifest.hl", "index.theme", "cursor.theme"):
    path = DST / name

    if path.is_file():
        content = path.read_text()
        content = content.replace(
            "Bibata-Modern-Ice", "Eclipse-Dark"
        )
        path.write_text(content)

print("ECLIPSE DARK: READY")
print(DST)
