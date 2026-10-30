#!/bin/sh
set -eu

# Bootstrap installer for the public RemoPilot macOS release.
# It downloads the signed archive, verifies SHA256SUMS, then runs the
# installer contained in the archive. It does not build from source.

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
ARCHIVE="remopilot-${VERSION}-${TARGET}.tar.gz"
TMPDIR_ROOT="${TMPDIR:-/tmp}"
TMP="$(mktemp -d "${TMPDIR_ROOT%/}/remopilot-install.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT INT TERM

echo "Downloading ${ARCHIVE}..."
curl -fL --retry 3 --retry-delay 2 -o "${TMP}/${ARCHIVE}" "${BASE}/${ARCHIVE}"
curl -fL --retry 3 --retry-delay 2 -o "${TMP}/SHA256SUMS" "${BASE}/SHA256SUMS"

(
  cd "$TMP"
  grep -F "  ${ARCHIVE}" SHA256SUMS | shasum -a 256 -c -
)

tar -xzf "${TMP}/${ARCHIVE}" -C "$TMP"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Verified ${ARCHIVE} and SHA256SUMS. Dry run: installation was not started."
  exit 0
fi

echo "Installing RemoPilot ${VERSION} (${TARGET})..."
(
  cd "$TMP"
  sh ./install.sh
)

echo "Run 'remopilot setup' to pair this Mac."
