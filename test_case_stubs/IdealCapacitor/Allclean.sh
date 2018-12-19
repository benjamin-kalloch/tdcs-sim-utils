#!/bin/bash

rm -rf ./constant/polyMesh/

for d in ./*; do
    if [[ "$d" =~ [0-9]+$ ]]; then
        rm -rf $d
    fi
done