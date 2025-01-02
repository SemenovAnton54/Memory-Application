#!/usr/bin/env sh

XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/File Templates/Memory'

echo "==> Copying up Xcode file templates..."

if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -R "$XCODE_TEMPLATE_DIR"
fi

mkdir -p "$XCODE_TEMPLATE_DIR"

cp -R 'StoreModule.xctemplate' "$XCODE_TEMPLATE_DIR"
