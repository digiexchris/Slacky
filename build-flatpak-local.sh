#!/bin/bash
# Build flatpak locally using Docker (same environment as CI)
# This bypasses WSL D-Bus issues

set -e

# Default to x86_64, can be overridden with: ./build-flatpak-local.sh arm64
ARCH=${1:-x86_64}

if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
  DOCKER_PLATFORM="linux/arm64"
  FLATPAK_ARCH="aarch64"
elif [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "amd64" ]; then
  DOCKER_PLATFORM="linux/amd64"
  FLATPAK_ARCH="x86_64"
else
  echo "Unknown architecture: $ARCH"
  echo "Usage: $0 [x86_64|arm64]"
  exit 1
fi

IMAGE_NAME="slacky-flatpak-builder:$FLATPAK_ARCH"

echo "Building Docker image for $FLATPAK_ARCH..."
docker build \
  --platform=$DOCKER_PLATFORM \
  --add-host=dl.flathub.org:151.101.129.91 \
  --build-arg FLATPAK_ARCH=$FLATPAK_ARCH \
  -t $IMAGE_NAME \
  -f Dockerfile.flatpak-builder \
  .

echo ""
echo "Building Slacky flatpak for $FLATPAK_ARCH using..."
echo "Docker platform: $DOCKER_PLATFORM"
echo ""


export DEBUG="@malept/flatpak-bundler" # Enable flatpak-bundler debug output

docker run --rm -it \
  --platform=$DOCKER_PLATFORM \
  --add-host=dl.flathub.org:151.101.129.91 \
  --privileged \
  -v "$(pwd):/workspace" \
  -w /workspace \
  $IMAGE_NAME \
  flatpak-builder --force-clean --disable-rofiles-fuse --arch=$FLATPAK_ARCH --repo=repo build-dir flatpak-manifest.yml # --install-deps-from=flathub

echo ""
echo "Build complete! Output in build-dir/"
echo "Flatpak bundle can be created with:"
echo "  flatpak build-bundle repo slacky-$FLATPAK_ARCH.flatpak com.andersonlaverde.slacky --arch=$FLATPAK_ARCH"
