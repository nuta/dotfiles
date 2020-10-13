#!/usr/bin/env python3
import argparse
import sys
import os
from tempfile import TemporaryDirectory
import subprocess
from pathlib import Path

PREAMBLES = r"""
\documentclass[aspectratio=43,dvipdfmx]{beamer}
\usepackage{bxdpx-beamer}%
\usepackage[utf8]{inputenc}
\usepackage[deluxe,expert]{otf}
\usepackage{array,colortbl}
\usepackage{pxjahyper}
\usepackage{minijs}
\usetheme{Copenhagen}
\renewcommand{\kanjifamilydefault}{\gtdefault}

\usecolortheme{rose}
\setbeamertemplate{title page}[default][colsep=-4bp,rounded=true]
\setbeamertemplate{footline}[frame number]
\setbeamertemplate{navigation symbols}{}
\useinnertheme{circles}
\setbeamertemplate{blocks}[rounded][shadow=false]

\title{$title}
\author{Seiya Nuta\\\footnotesize{nuta@seiya.me}}
\begin{document}
\frame{\titlepage}

\begin{frame}
    \frametitle{こんにちは!!!!!!!!}
    ああa
\begin{block}{おｋ}
    ああ
\end{block}

\end{frame}
\end{document}
"""

def md2latex(md_text):
    md = 
    tex = PREAMBLES.Template().substitute(**locals())

def tex2pdf(tex, pdf_path):
    pdf_path = pdf_path.resolve()
    with TemporaryDirectory() as tempdir:
        os.chdir(tempdir)
        print(tex)
        open("slides.tex", "w").write(tex)
        for _ in range(0, 2):
            subprocess.run([
                "platex", "-kanji=utf8", "-synctex=1", "-file-line-error",
                "-halt-on-error", "-interaction=nonstopmode",
                "slides.tex"
            ], check=True)
        subprocess.run([
            "dvipdfmx", "slides"
        ], check=True)
        os.rename("slides.pdf", pdf_path)   

def md_file2pdf(md_path, pdf_path):
    md = open(md_path, "r").read()
    tex = md2latex(md)
    tex2pdf(tex, pdf_path)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("md_file")
    parser.add_argument("--no-watch", action="store_false")
    args = parser.parse_args()

    md_path = Path(args.md_file)
    md_file2pdf(md_path, Path(md_path.stem + ".pdf"))

if __name__ == "__main__":
    main()
