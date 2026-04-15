#!/usr/bin/env python3
"""
Convert src/songlinchen_20260321.tex body to GitHub-flavored Markdown.
Single-purpose script for this CV layout; extend patterns if the .tex grows.
"""
from __future__ import annotations

import re
import sys


def strip_latex_comments(s: str) -> str:
    out = []
    for line in s.split("\n"):
        if "%" in line:
            # strip unescaped % comments
            parts = []
            i = 0
            while i < len(line):
                if line[i] == "%" and (i == 0 or line[i - 1] != "\\"):
                    break
                parts.append(line[i])
                i += 1
            line = "".join(parts).rstrip()
        out.append(line)
    return "\n".join(out)


def subst_inline(s: str) -> str:
    s = re.sub(r"\\textbf\{([^}]*)\}", r"**\1**", s)
    s = re.sub(
        r"\\href\{([^}]*)\}\{([^}]*)\}",
        lambda m: f"[{m.group(2)}]({m.group(1)})",
        s,
    )
    s = s.replace(r"\&", "&")
    s = s.replace(r"\_", "_")
    return s


def parse_itemize(block: str) -> str:
    lines = []
    for raw in block.strip().split("\n"):
        raw = raw.strip()
        if raw.startswith("\\item"):
            rest = raw[5:].strip()
            lines.append("- " + subst_inline(rest))
    return "\n".join(lines) if lines else block


def tex_body_to_markdown(body: str) -> str:
    body = strip_latex_comments(body)

    # Header: \begin{center} ... \end{center}
    cm = re.search(
        r"\\begin\{center\}(.*?)\\end\{center\}",
        body,
        re.DOTALL,
    )
    header_md = "# Song-Lin Chen\n\n"
    if cm:
        inner = cm.group(1)
        name_m = re.search(r"\{\\LARGE\s*\\textbf\{([^}]*)\}\s*\}", inner)
        name = name_m.group(1).strip() if name_m else "Song-Lin Chen"
        tail = inner[name_m.end() :] if name_m else inner
        tail = tail.replace(r"\small", "")
        tail = re.sub(r"\\vspace\{[^}]*\}", "", tail)
        tail = re.sub(r"\s*\\AND\s*", " · ", tail)
        tail = subst_inline(tail)
        tail = re.sub(r"\s+", " ", tail).strip()
        header_md = f"# {name}\n\n{tail}\n\n---\n\n"
        body = body[: cm.start()] + body[cm.end() :]

    sections: list[str] = []
    pos = 0
    while pos < len(body):
        sec_m = re.search(r"\\section\{([^}]*)\}", body[pos:])
        if not sec_m:
            break
        title = subst_inline(sec_m.group(1).replace(r"\&", "&"))
        start = pos + sec_m.end()
        next_sec = re.search(r"\\section\{", body[start:])
        chunk_end = start + next_sec.start() if next_sec else len(body)
        chunk = body[start:chunk_end].strip()
        pos = chunk_end

        sec_lines = [f"## {title}", ""]

        if "\\begin{itemize}" in chunk:
            pre, rest = chunk.split("\\begin{itemize}", 1)
            items, post = rest.split("\\end{itemize}", 1)
            if pre.strip():
                sec_lines.append(subst_inline(pre.strip()) + "\n")
            sec_lines.append(parse_itemize(items))
            if post.strip():
                sec_lines.append("")
                sec_lines.append(subst_inline(post.strip()))
        else:
            # Paragraphs: \\ or blank lines
            chunk = subst_inline(chunk)
            chunk = re.sub(r"\\\\\s*", "\n\n", chunk)
            chunk = re.sub(r"\\vspace\{[^}]*\}", "", chunk)
            sec_lines.append(chunk.strip())
        sections.append("\n".join(sec_lines))

    return header_md + "\n\n".join(sections) + "\n"


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: tex_to_md_songlinchen.py <input.tex> <output.md>", file=sys.stderr)
        sys.exit(2)
    tex_path, md_path = sys.argv[1], sys.argv[2]
    raw = open(tex_path, encoding="utf-8").read()
    doc_m = re.search(r"\\begin\{document\}(.*)\\end\{document\}", raw, re.DOTALL)
    if not doc_m:
        print("No \\begin{document} ... \\end{document}", file=sys.stderr)
        sys.exit(1)
    md = tex_body_to_markdown(doc_m.group(1))
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(md)


if __name__ == "__main__":
    main()
