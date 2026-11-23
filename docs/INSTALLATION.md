# RemoPilot installation

## Availability

Version `1.0.26` provides macOS packages for Apple Silicon and Intel Macs. Other platforms are not part of this release.

Install only the archive for the Mac you are using. Never paste a GitHub token, pairing code, private key or other credential into these instructions, chat or an issue.

## Supported packages

New macOS releases are prepared as signed, notarized DMG images. The table
below describes the published GitHub `1.0.26` release, which predates that
change; no DMG or checksum is implied for an existing release.

| Package | Machine |
|---|---|
| `remopilot-1.0.26-darwin-arm64.tar.gz` | Apple Silicon Mac |
| `remopilot-1.0.26-darwin-x64.tar.gz` | Intel Mac |

Both archives are Developer ID signed and notarized. The Apple Silicon package is signed, notarized and tested for installation and CLI startup. The Intel package has not yet been fully verified on a physical Intel Mac; check pairing, background-service access and cold-start behavior on the target machine.

Native app control requires macOS 14 or later, a usable desktop session and the system permissions you choose to grant.

## Install with Homebrew

```sh
brew tap --custom-remote remopilot/remopilot https://github.com/remopilot/remopilot.git
brew install remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot setup
```

The explicit `--custom-remote` form selects this repository. `brew install` only places the verified package in Cellar and provides a launcher. Activation verifies the candidate again, retains the package outside Cellar and uses the normal RemoPilot installer. Activation does not log in, pair the machine, register a service or grant permissions by itself.

If Homebrew is not installed, follow its [official installation guide](https://docs.brew.sh/Installation).

## Install from a DMG

When the selected release includes a DMG for your Mac, download it and
`SHA256SUMS` from that same release. Compare the DMG's SHA-256 with its matching
line, open the image, and double-click `Install RemoPilot.command`. Follow the
Terminal prompts to complete installation and pairing. The image contains the
managed installer; it is not a drag-to-Applications installation.

## Install the published 1.0.26 archive

1. Download `remopilot-1.0.26-darwin-arm64.tar.gz` or `remopilot-1.0.26-darwin-x64.tar.gz` from the versioned Release.
2. Download `SHA256SUMS` from the same Release.
3. Verify and install:

```sh
grep '  remopilot-1.0.26-darwin-arm64.tar.gz$' SHA256SUMS | shasum -a 256 -c -
tar -xzf remopilot-1.0.26-darwin-arm64.tar.gz
sh install.sh
remopilot setup
```

Use the `x64` archive on an Intel Mac. The archive contains the signed CLI, the desktop helper, the native `RemoPilot.app`, the embedded Skills, manifests, publisher-signature data, dependency notices and the relinking material required by the bundled runtime license.

The installer verifies the publisher signature and the package layout before writing the managed installation. It does not overwrite an unrelated App, follow package symlinks or accept a package for another target. Existing configuration, pairing and permissions are retained.

### Bootstrap script

The repository provides a bootstrap script for the same archive flow:

```sh
curl -fsSL https://raw.githubusercontent.com/remopilot/remopilot/main/install.sh -o install.sh
less install.sh
sh install.sh
```

It detects `arm64` or `x86_64`, downloads `SHA256SUMS` and selects the matching DMG if the release lists one; otherwise it uses the older archive. It verifies the checksum and, for a DMG, checks the image signature and Gatekeeper assessment before mounting it read-only and running its installer. Use `sh install.sh --dry-run` to stop after checksum verification without mounting or installing. Review the script before running it. It does not compile the product or require a source checkout.

## Pairing and permissions

When `setup` displays a machine code, open the pairing page yourself in a browser, sign in, enter that code on the computer and review the requested directories and capabilities. Do not send a pairing code to an assistant.

Grant only what you intend to use:

- Accessibility supports native app structure and input.
- Screen Recording is needed for app images and the separately enabled read-only desktop view.
- Project directory authorization is separate from terminal access. A readable terminal does not prove the background service can read the same directory.

The signed `RemoPilot.app` provides permission status and authorization entry points. Signing continuity cannot guarantee that macOS never asks again after an OS or permission change.

## Plugins and projects

The machine runtime, cloud service and Claude or Codex plugin are separate deliveries. The `1.4.0` plugin bundles use a new MCP tool contract; install them only after the matching cloud tool catalog has been deployed and validated. The public installation may still offer an older plugin. After a compatible plugin update, reconnect it in the host and start a new conversation so the current Skills and tools load. Keep original binding and request identifiers for unfinished work and recover the original request without replaying it.

In a conversation, select a paired computer and an authorized project, then follow that project's own dependency installation and build instructions. Installing RemoPilot or its plugin does not install the project's dependencies.

The computer owner can explicitly add supported local Skills and external MCP servers through the machine client. Reading their catalog does not start an MCP server or install dependencies. Some host-specific configuration or authorization schemes are unsupported, and external tools remain accessible through RemoPilot's operations rather than becoming native host tools automatically.

## Upgrade

```sh
brew update
brew upgrade remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot version
remopilot status
```

macOS managed services use a direct update. The running service is stopped and replaced without waiting for old tasks to become idle. Tasks and gateway sessions that are running during the switch are interrupted; the update receipt reports the interrupted count and App entity count when readable (`null` means the value could not be read, not zero). Existing request IDs, receipts and configuration remain available for recovery where the installed version supports it.

If activation refuses because work is active, an execution is uncertain or a handshake is incomplete, keep the original request IDs and follow the returned guidance. Do not terminate tasks, delete locks or replay an uncertain execution to force an upgrade.

For an existing custom installation, keep the same output prefix and configuration path:

```sh
export REMOPILOT_HOMEBREW_PREFIX=/absolute/installation
remopilot homebrew --action install --config /absolute/work/.remopilot/agent/config.json
```

`brew cleanup` or `brew uninstall` removes only the Cellar package and launcher. Managed programs, generations and machine data remain outside Cellar. Use RemoPilot's service commands rather than `brew services`.

## Downloads and integrity

The versioned `v1.0.26` Release contains the two macOS archives and `SHA256SUMS`. Select the archive matching the Mac architecture and compare its SHA-256 with the corresponding line:

```sh
shasum -a 256 remopilot-1.0.26-darwin-arm64.tar.gz
```

Published version archives are not replaced. If a package is wrong, a new version is prepared with new checksums. The release feed, the cloud service, the machine agent and the home plugin are separate release surfaces; publishing this repository does not update an installed service.
