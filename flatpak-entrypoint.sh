#!/bin/bash
#since flatpak-builder can't access the outside environment while building, build inside the container but don't do any node stuff in the flatpak build steps

npm install --include=dev --pure-lockfile
npm run app:dir #build the electron app, but don't package anything

npm install --production --pure-lockfile #remove dev dependencies
flatpak-node-generator npm ./package-lock.json

# run this in your action: flatpak-builder --force-clean --disable-rofiles-fuse --arch=$FLATPAK_ARCH --repo=repo build-dir flatpak-manifest.yml