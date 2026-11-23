#!/bin/sh
set -eu

# Bootstrap installer for the public RemoPilot macOS release.
# It verifies the release checksum and runs the installer in the DMG.
# Older releases that only published archives remain installable.

REPO="remopilot/remopilot"
VERSION="1.0.26"

DRY_RUN=0
case "${1:-}" in
  "") ;;
  --dry-run)
    DRY_RUN=1
    ;;
  *)
    echo "Usage: $0 [--dry-run]" >&2
    exit 2
    ;;
esac

case "$(uname -s)" in
  Darwin) ;;
  *)
    echo "RemoPilot ${VERSION} provides macOS packages only." >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  arm64)
    TARGET="darwin-arm64"
    ;;
  x86_64)
    TARGET="darwin-x64"
    ;;
  *)
    echo "Unsupported Mac architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

BASE="https://github.com/${REPO}/releases/download/v${VERSION}"
STEM="remopilot-${VERSION}-${TARGET}"
TMPDIR_ROOT="${TMPDIR:-/tmp}"
TMP="$(mktemp -d "${TMPDIR_ROOT%/}/remopilot-install.XXXXXX")"
MOUNTED=0
cleanup() {
  if [ "$MOUNTED" -eq 1 ]; then
    if ! hdiutil detach "$TMP/volume" >/dev/null; then
      echo "Could not detach $TMP/volume; preserving the temporary directory." >&2
      return
    fi
  fi
  rm -rf "$TMP"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

curl -fL --retry 3 --retry-delay 2 -o "${TMP}/SHA256SUMS" "${BASE}/SHA256SUMS"
DMG_COUNT=$(awk -v name="${STEM}.dmg" '$2 == name { found++ } END { print found + 0 }' "$TMP/SHA256SUMS")
if [ "$DMG_COUNT" -gt 1 ]; then
  echo "Duplicate checksum entries for ${STEM}.dmg." >&2
  exit 1
elif [ "$DMG_COUNT" -eq 1 ]; then
  PACKAGE="${STEM}.dmg"
else
  PACKAGE="${STEM}.tar.gz"
fi
echo "Downloading ${PACKAGE}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP}/${PACKAGE}" "${BASE}/${PACKAGE}"

(
  cd "$TMP"
  awk -v name="$PACKAGE" '$2 == name { print; found++ } END { if (found != 1) exit 1 }' SHA256SUMS > selected.sha256
  shasum -a 256 -c selected.sha256
)

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Verified ${PACKAGE} and SHA256SUMS. Dry run: installation was not started."
  exit 0
fi

echo "Installing RemoPilot ${VERSION} (${TARGET})..."
case "$PACKAGE" in
  *.dmg)
    codesign --verify --strict "$TMP/$PACKAGE"
    spctl --assess --type open --context context:primary-signature "$TMP/$PACKAGE"
    mkdir "$TMP/volume"
    hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$TMP/volume" "$TMP/$PACKAGE" >/dev/null
    MOUNTED=1
    SOURCE="$TMP/volume"
    ;;
  *)
    tar -xzf "$TMP/$PACKAGE" -C "$TMP"
    SOURCE="$TMP"
    ;;
esac
(
  cd "$SOURCE"
  sh ./install.sh
)

echo "Run 'remopilot setup' to pair this Mac."
