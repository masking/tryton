#!/bin/bash

GDRIVE_FOLDER_ID=1kDCUVHp45sil3zXfpaK_bdMJHXTzIrIl

version() {
    local t
    t=$(git describe --tags --exact-match 2> /dev/null | grep "^coog-" | head -1)
    if [ ! -z "$t" ]
    then
        echo "${t//coog-/}"
    else
        local b; b=$(git rev-parse --abbrev-ref HEAD)
        local c; c=$(git rev-parse --short HEAD)
        echo "$b-$c" | sed -e "s/coog-//g"
    fi
}

deps() {
    pacman -S \
        mingw-w64-i686-librsvg \
        mingw-w64-i686-nsis \
        mingw-w64-i686-python2 \
        mingw-w64-i686-python2-setuptools \
        mingw-w64-i686-python2-pip \
        mingw-w64-i686-gtk3 \
        mingw-w64-i686-python2-gobject \
        mingw-w64-i686-python3-gobject \
        mingw-w64-gtksourceview3 \
        mingw-w64-i686-gtkglext \
        mingw-w64-i686-python2-cx_Freeze

    pip install \
        python-dateutil \
        chardet \
        pyflakes

    echo "gdrive should be installed from https://github.com/prasmussen/gdrive#downloads"
    echo "gdrive should be placed in a PATH folder"
}

clean() {
    rm -rf build dist coog-*
}

build() {
    clean
    local v; v=$(version)
    python setup-freeze.py install_exe -d dist
    makensis -DVERSION="$v" setup.nsi
    makensis -DVERSION="$v" setup-single.nsi
}

upload() {
    for f in ./coog-*
    do
        gdrive upload -p "$GDRIVE_FOLDER_ID" "$f"
    done
}

main() {
    [ -z "$1" ] && echo missing command && return 1
    "$1" "$@"
}

main "$@"