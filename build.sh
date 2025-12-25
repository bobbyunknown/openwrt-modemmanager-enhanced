#!/bin/bash
set -e

SDK_TAG="${SDK_TAG:-x86-64-openwrt-24.10}"
REGISTRY="${REGISTRY:-ghcr.io}"

echo "Building ModemManager packages with OpenWRT SDK: $REGISTRY/openwrt/sdk:$SDK_TAG"

# Create cache directories if not exist
mkdir -p bin dl feeds_cache

docker run --rm \
  -v "$(pwd)"/bin/:/builder/bin \
  -v "$(pwd)"/dl/:/builder/dl \
  -v "$(pwd)"/feeds_cache/:/builder/feeds \
  -v "$(pwd)"/modemmanager:/builder/modemmanager \
  -v "$(pwd)"/luci-proto-modemmanager:/builder/luci-proto-modemmanager \
  -v "$(pwd)"/libmbim:/builder/libmbim \
  -it $REGISTRY/openwrt/sdk:$SDK_TAG \
  bash -c '
    # Setup SDK if needed
    [ ! -d ./scripts ] && ./setup.sh
    
    # Create custom feed directory
    mkdir -p feeds/custom
    
    # Link our packages to feeds
    ln -sf /builder/libmbim feeds/custom/
    ln -sf /builder/modemmanager feeds/custom/
    ln -sf /builder/luci-proto-modemmanager feeds/custom/
    
    # Add custom feed to feeds.conf (at TOP so it has priority over default feeds)
    sed -i "1i src-link custom /builder/sdk/feeds/custom" feeds.conf.default
    
    # Update and install feeds (ignore errors from base feed)
    ./scripts/feeds update -a || true
    ./scripts/feeds install -p custom -a
    
    # Configure - enable our custom packages
    make defconfig
    
    # Enable our packages in .config
    echo "CONFIG_PACKAGE_libmbim=m" >> .config
    echo "CONFIG_PACKAGE_modemmanager=m" >> .config
    echo "CONFIG_PACKAGE_luci-proto-modemmanager=m" >> .config
    
    # Build all packages at once
    echo "=== Building all packages ==="
    make -j$(nproc) V=s
    
    echo "=== Build complete! Check ./bin/ directory ==="
    ls -lh bin/packages/*/custom/ || echo "No custom packages found"
  '
