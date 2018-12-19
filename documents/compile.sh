#!/bin/bash

continue_promt()
{
    read -n 1 -s -r -p ">>>>>>PROCEED?"
}


pdflatex -output-directory output main.tex

continue_promt

bibtex output/main.aux

continue_promt

pdflatex -output-directory output main.tex

pdflatex -output-directory output main.tex