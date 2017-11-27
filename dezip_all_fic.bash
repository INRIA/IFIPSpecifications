#!/bin/bash
Listezip="$(find *.zip -type f )"   # liste des repertoires sans leurs sous-repertoires
for fic in ${Listezip}; do
  unzip $fic;
done
find . -name BookFrontmatter.xml -print0 | xargs -0 grep "CopyrightYear" |sort -u >/tmp/res.txt
