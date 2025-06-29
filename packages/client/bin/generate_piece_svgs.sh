#!/bin/bash

# Compile SVGs for black pieces.
dart run vector_graphics_compiler --input-dir assets/raw/black --out-dir assets/piece_sets/wikimedia

# Compile SVGs for the rest of the different colored pieces.
#
# These SVGs use `currentColor` for the fill.  We can use the following command
# to create vector graphics file for all the different piece colors, other than
# black.
declare -A colors
# Tol's color palette - discrete rainbow
# Reference:
# - https://personal.sron.nl/~pault/data/colourschemes.pdf
# - https://www.ibm.com/design/language/color/
colors["ash"]="0xFFCCCCCC"
colors["cyan"]="0xFF7BAFDE"
colors["green"]="0xFF4EB265"
colors["navy"]="0xFF1965B0"
colors["orange"]="0xFFF4A736"
# NOTE: Used pink from IBM color palette as there was no pink in Tol's.
colors["pink"]="0xFFFFAFD2"
colors["red"]="0xFFDC050C"
colors["slate"]="0xEE586e75"
colors["violet"]="0xFF882E72"
colors["white"]="0xFFFFFFFF"
colors["yellow"]="0xFFF7F056"

declare -a pieces=("B" "K" "N" "P" "Q" "R")

for color in "${!colors[@]}"; do
  color_letter="${color:0:1}"

  for piece in "${pieces[@]}"; do
    echo "Compiling SVG: ${color} ${piece}"
    dart run vector_graphics_compiler "--current-color=${colors[${color}]}" -i "assets/raw/currentColor/${piece}.svg" -o "assets/piece_sets/wikimedia/${color_letter}${piece}.svg.vec"
  done
done
