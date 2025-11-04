#!/bin/bash
# Wrapper script to launch Slacky via zypak for proper Electron sandboxing
export TMPDIR="$XDG_RUNTIME_DIR/app/$FLATPAK_ID"
exec zypak-wrapper /app/main/node_modules/.bin/electron /app/main/dist/app/src/app.js "$@"
