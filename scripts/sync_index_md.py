#!/usr/bin/env python3
"""Write repo-root index.md for GitHub Pages from markdown/songlinchen_20260321.md."""
from __future__ import annotations

import sys


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: sync_index_md.py <cv.md> <index.md>", file=sys.stderr)
        sys.exit(2)
    cv_path, index_path = sys.argv[1], sys.argv[2]
    body = open(cv_path, encoding="utf-8").read().rstrip()
    footer = """

---

📄 **[Download PDF resume]({{ '/output/songlinchen_20260321.pdf' | relative_url }})**
"""
    with open(index_path, "w", encoding="utf-8") as f:
        f.write(
            "---\n"
            "layout: default\n"
            "title: Song Lin Chen\n"
            "---\n\n"
        )
        f.write(body)
        f.write(footer)
        if not footer.endswith("\n"):
            f.write("\n")


if __name__ == "__main__":
    main()
