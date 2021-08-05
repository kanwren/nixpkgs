#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

# Update script for the vscode versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/vscode.nix" ]; then
  echo "ERROR: cannot find vscode.nix in $ROOT"
  exit 1
fi

# VSCode

VSCODE_VER=$(curl --fail --silent https://api.github.com/repos/Microsoft/vscode/releases/latest | jq --raw-output .tag_name)
sed -i "s/version = \".*\"/version = \"${VSCODE_VER}\"/" "$ROOT/vscode.nix"

VSCODE_X64_LINUX_URL="https://update.code.visualstudio.com/${VSCODE_VER}/linux-x64/stable"
VSCODE_X64_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_X64_LINUX_URL})
sed -i "s/x86_64-linux = \".\{52\}\"/x86_64-linux = \"${VSCODE_X64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_X64_DARWIN_URL="https://update.code.visualstudio.com/${VSCODE_VER}/darwin/stable"
VSCODE_X64_DARWIN_SHA256=$(nix-prefetch-url ${VSCODE_X64_DARWIN_URL})
sed -i "s/x86_64-darwin = \".\{52\}\"/x86_64-darwin = \"${VSCODE_X64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_AARCH64_LINUX_URL="https://update.code.visualstudio.com/${VSCODE_VER}/linux-arm64/stable"
VSCODE_AARCH64_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_AARCH64_LINUX_URL})
sed -i "s/aarch64-linux = \".\{52\}\"/aarch64-linux = \"${VSCODE_AARCH64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_AARCH64_DARWIN_URL="https://update.code.visualstudio.com/${VSCODE_VER}/darwin-arm64/stable"
VSCODE_AARCH64_DARWIN_SHA256=$(nix-prefetch-url ${VSCODE_AARCH64_DARWIN_URL})
sed -i "s/aarch64-darwin = \".\{52\}\"/aarch64-darwin = \"${VSCODE_AARCH64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_ARMV7L_LINUX_URL="https://update.code.visualstudio.com/${VSCODE_VER}/linux-armhf/stable"
VSCODE_ARMV7L_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_ARMV7L_LINUX_URL})
sed -i "s/armv7l-linux = \".\{52\}\"/armv7l-linux = \"${VSCODE_ARMV7L_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

# insiders

VSCODE_INSIDERS_X64_LINUX_URL="https://code.visualstudio.com/sha/download?build=insider&os=linux-x64"
VSCODE_INSIDERS_X64_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_INSIDERS_X64_LINUX_URL} --name vscode-insiders-linux-x64)
sed -i "s/x86_64-linux_insiders = \".\{52\}\"/x86_64-linux_insiders = \"${VSCODE_INSIDERS_X64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_INSIDERS_X64_DARWIN_URL="https://code.visualstudio.com/sha/download?build=insider&os=darwin"
VSCODE_INSIDERS_X64_DARWIN_SHA256=$(nix-prefetch-url ${VSCODE_INSIDERS_X64_DARWIN_URL} --name vscode-insiders-darwin)
sed -i "s/x86_64-darwin_insiders = \".\{52\}\"/x86_64-darwin_insiders = \"${VSCODE_INSIDERS_X64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_INSIDERS_AARCH64_LINUX_URL="https://code.visualstudio.com/sha/download?build=insider&os=linux-arm64"
VSCODE_INSIDERS_AARCH64_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_INSIDERS_AARCH64_LINUX_URL} --name vscode-insiders-linux-arm64)
sed -i "s/aarch64-linux_insiders = \".\{52\}\"/aarch64-linux_insiders = \"${VSCODE_INSIDERS_AARCH64_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_INSIDERS_AARCH64_DARWIN_URL="https://code.visualstudio.com/sha/download?build=insider&os=darwin-arm64"
VSCODE_INSIDERS_AARCH64_DARWIN_SHA256=$(nix-prefetch-url ${VSCODE_INSIDERS_AARCH64_DARWIN_URL} --name vscode-insiders-darwin-arm64)
sed -i "s/aarch64-darwin_insiders = \".\{52\}\"/aarch64-darwin_insiders = \"${VSCODE_INSIDERS_AARCH64_DARWIN_SHA256}\"/" "$ROOT/vscode.nix"

VSCODE_INSIDERS_ARMV7L_LINUX_URL="https://code.visualstudio.com/sha/download?build=insider&os=linux-armhf"
VSCODE_INSIDERS_ARMV7L_LINUX_SHA256=$(nix-prefetch-url ${VSCODE_INSIDERS_ARMV7L_LINUX_URL} --name vscode-insiders-linux-armhf)
sed -i "s/armv7l-linux_insiders = \".\{52\}\"/armv7l-linux_insiders = \"${VSCODE_INSIDERS_ARMV7L_LINUX_SHA256}\"/" "$ROOT/vscode.nix"
