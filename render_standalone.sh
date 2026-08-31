#!/bin/bash

# Simple script to export a Pico-8 cartridge to a standalone HTML file.
# Note: The .p8 cartridge MUST contain a __label__ section (a captured cover image).
# If it doesn't, the export will fail. You can create a label in Pico-8 by pressing F7.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <cartridge.p8>"
    exit 1
fi

CART="$1"

if [ ! -f "$CART" ]; then
    echo "Error: File '$CART' not found!"
    exit 1
fi

# Extract filename without extension
BASENAME=$(basename "$CART" .p8)
# Remove .png extension if it was passed as .p8.png
BASENAME=$(basename "$BASENAME" .png)
# Remove .p8 again if the file was .p8.png
BASENAME=$(basename "$BASENAME" .p8)

PICO8_BIN="/Applications/PICO-8.app/Contents/MacOS/pico8"

if [ ! -x "$PICO8_BIN" ]; then
    echo "Error: Pico-8 executable not found at $PICO8_BIN"
    exit 1
fi

HTML_FILE="${BASENAME}.html"

echo "Exporting '$CART' to HTML..."
"$PICO8_BIN" "$CART" -export "$HTML_FILE"

if [ $? -eq 0 ]; then
    echo "Success! Created $HTML_FILE (and ${BASENAME}.js)"
else
    echo "Export failed."
    echo "Make sure your cartridge has a captured label image (press F7 in Pico-8 to capture)."
    exit 1
fi
