#!/usr/bin/env python3
"""
Convert src/songlinchen_20260321.tex (RenderCV-style) to GitHub-flavored Markdown.
Strips layout environments (twocolentry, onecolentry, highlights) and preserves content.
"""
from __future__ import annotations

import re
import sys


def strip_latex_comments(s: str) -> str:
    out = []
    for line in s.split("\n"):
        if "%" in line:
            i = 0
            buf = []
            while i < len(line):
                if line[i] == "%" and (i == 0 or line[i - 1] != "\\"):
                    break
                buf.append(line[i])
                i += 1
            line = "".join(buf).rstrip()
        out.append(line)
    return "\n".join(out)


def take_brace_group(s: str, start: int) -> tuple[str, int]:
    if start >= len(s) or s[start] != "{":
        raise ValueError("expected {")
    depth = 0
    i = start
    while i < len(s):
        if s[i] == "{":
            depth += 1
        elif s[i] == "}":
            depth -= 1
            if depth == 0:
                return s[start + 1 : i], i + 1
        i += 1
    raise ValueError("unbalanced brace")


def strip_display_noise(s: str) -> str:
    s = re.sub(r"\\color\{[^}]*\}\{((?:[^{}]|\{[^{}]*\})*)\}", r"\1", s)
    s = re.sub(r"\\footnotesize\s*", "", s)
    s = re.sub(r"\\[fa][A-Za-z]+(?:\[[^\]]*\])?\*?", "", s)
    s = re.sub(r"\\hspace\*?\{[^}]*\}", "", s)
    s = re.sub(r"\}+", "}", s)
    s = re.sub(r"\s+", " ", s).strip().rstrip("}")
    return s


def subst_inline(s: str) -> str:
    s = s.replace(r"\textasciitilde{}", "~")
    s = s.replace(r"\textasciitilde", "~")
    s = re.sub(r"\\texttt\{([^}]*)\}", r"`\1`", s)
    s = s.replace(r"\&", "&")
    s = s.replace(r"\_", "_")
    s = s.replace(r"\%", "%")

    for _ in range(10):
        prev = s
        s = re.sub(r"\\textit\{((?:[^{}]|\{[^{}]*\})*)\}", r"*\1*", s)
        s = re.sub(r"\\textbf\{((?:[^{}]|\{[^{}]*\})*)\}", r"**\1**", s)
        if s == prev:
            break
    return s


def parse_href_without_arrow(s: str, pos: int):
    key = r"\hrefWithoutArrow{"
    if not s.startswith(key, pos):
        return None
    p = pos + len(key) - 1
    url, p = take_brace_group(s, p)
    inner, p = take_brace_group(s, p)
    url = url.replace("\n", "").replace("\r", "").strip()
    return url, inner, p


def parse_header_simple(inner: str) -> str:
    parts: list[str] = ["# Song Lin Chen", ""]
    hrefs: list[str] = []
    i = 0
    n = len(inner)
    while i < n:
        if inner.startswith(r"\hrefWithoutArrow{", i):
            h = parse_href_without_arrow(inner, i)
            if h:
                url, raw, i = h
                t = strip_display_noise(raw)
                if t:
                    hrefs.append(f"[{t}]({url})")
                continue
        i += 1

    row: list[str] = []
    if hrefs:
        row.append(hrefs[0])
    if r"\faMapMarker" in inner and "Taiwan" in inner:
        row.append("Taiwan")
    row.extend(hrefs[1:])

    if row:
        parts.append(" · ".join(row))
        parts.append("")
    parts.append("---")
    parts.append("")
    return "\n".join(parts)


def parse_items(highlights_body: str) -> str:
    bullets: list[str] = []
    for raw in highlights_body.strip().split("\n"):
        t = raw.strip()
        if t.startswith("\\item"):
            rest = t[5:].strip()
            bullets.append("- " + subst_inline(rest))
    return "\n".join(bullets)


def render_twocol(arg: str, body: str) -> str:
    # \textit{...} in arg already becomes *...* via subst_inline — do not wrap again
    arg_md = subst_inline(arg.strip()) if arg.strip() else ""
    body = body.strip()
    body = re.sub(r"\\\\\s*", "\n\n", body)
    lines = [ln.strip() for ln in body.split("\n") if ln.strip()]
    body_md = "\n\n".join(subst_inline(ln) for ln in lines)
    if arg_md:
        return f"{arg_md}\n\n{body_md}\n"
    return f"{body_md}\n"


def convert_section_chunk(chunk: str) -> str:
    chunk = re.sub(r"\\vspace\*?\{[^}]*\}", "", chunk)
    out: list[str] = []
    pos = 0
    chunk = chunk.strip()
    n = len(chunk)

    while pos < n:
        rest = chunk[pos:]
        if rest.startswith(r"\begin{twocolentry}"):
            pos += len(r"\begin{twocolentry}")
            if pos < n and chunk[pos] == "[":
                # optional [...]
                depth = 1
                i = pos + 1
                while i < n and depth:
                    if chunk[i] == "[":
                        depth += 1
                    elif chunk[i] == "]":
                        depth -= 1
                    i += 1
                pos = i
            if pos < n and chunk[pos] == "{":
                arg, pos = take_brace_group(chunk, pos)
            else:
                arg = ""
            end = chunk.find(r"\end{twocolentry}", pos)
            if end < 0:
                break
            body = chunk[pos:end].strip()
            pos = end + len(r"\end{twocolentry}")
            out.append(render_twocol(arg, body))
            continue

        if rest.startswith(r"\begin{onecolentry}"):
            pos += len(r"\begin{onecolentry}")
            end = chunk.find(r"\end{onecolentry}", pos)
            if end < 0:
                break
            inner = chunk[pos:end]
            pos = end + len(r"\end{onecolentry}")
            hm = re.search(
                r"\\begin\{highlights\}(.*?)\\end\{highlights\}",
                inner,
                re.DOTALL,
            )
            if hm:
                out.append(parse_items(hm.group(1)) + "\n")
            else:
                out.append(subst_inline(inner.strip()) + "\n")
            continue

        nxt = re.search(
            r"\\begin\{(twocolentry|onecolentry)\}",
            chunk[pos:],
        )
        if nxt and nxt.start() > 0:
            junk = chunk[pos : pos + nxt.start()].strip()
            if junk:
                out.append(subst_inline(junk) + "\n")
            pos += nxt.start()
            continue

        break

    return "\n".join(out).strip() + "\n"


def tex_body_to_markdown(body: str) -> str:
    body = strip_latex_comments(body)

    header_md = "# Song Lin Chen\n\n---\n\n"
    hm = re.search(r"\\begin\{header\}(.*?)\\end\{header\}", body, re.DOTALL)
    if hm:
        header_md = parse_header_simple(hm.group(1))
        body = body[: hm.start()] + body[hm.end() :]

    body = re.sub(r"\\vspace\*?\{[^}]*\}", "", body)

    sections: list[str] = []
    pos = 0
    while pos < len(body):
        sec_m = re.search(r"\\section\{((?:[^{}]|\{[^{}]*\})*)\}", body[pos:])
        if not sec_m:
            break
        title = subst_inline(sec_m.group(1).replace(r"\&", "&"))
        start = pos + sec_m.end()
        next_sec = re.search(r"\\section\{", body[start:])
        chunk_end = start + next_sec.start() if next_sec else len(body)
        chunk = body[start:chunk_end].strip()
        pos = chunk_end

        sec_body = convert_section_chunk(chunk)
        sections.append(f"## {title}\n\n{sec_body}".rstrip() + "\n")

    return header_md + "\n".join(sections)


def strip_preamble_in_body(inner: str) -> str:
    """Remove \\newcommand{\\\\AND} ... \\sbox blocks after \\begin{document}."""
    inner = re.sub(
        r"\\newcommand\{\\AND\}[\s\S]*?\\sbox\\ANDbox\{[^}]*\}\s*",
        "",
        inner,
        count=1,
    )
    return inner


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
    inner_doc = strip_preamble_in_body(doc_m.group(1))
    md = tex_body_to_markdown(inner_doc)
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(md)


if __name__ == "__main__":
    main()
