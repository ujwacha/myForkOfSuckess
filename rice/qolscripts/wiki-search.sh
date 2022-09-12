#!/bin/bash

# i just stole this from dt

wikidir="/usr/share/doc/arch-wiki/html/en/"

wikidocs="$(find ${wikidir} -iname "*.html")"

main() {
    choice=$(printf '%s\n' "${wikidocs[@]}" | \
           cut -d '/' -f8- | \
           sed -e 's/_/ /g' -e 's/.html//g' | \
           sort -g | \
           dmenu -l 20 -i -p 'Arch Wiki Docs: ') || exit 1

    if [ "$choice" ]; then
        article=$(printf '%s\n' "${wikidir}${choice}.html" | sed 's/ /_/g')
        firefox "$article"
    else
        echo "Program terminated." && exit 0
    fi
}

main
