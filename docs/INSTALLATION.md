# RemoPilot installation

## Availability

Version `1.0.24` provides macOS packages for Apple Silicon and Intel Macs. Windows and Linux packages are not provided in this release.

Install only the archive for the Mac you are using. Never paste a GitHub token, pairing code, private key or other credential into these instructions, chat or an issue.

## Supported packages

| Package | Machine |
|---|---|
| `remopilot-1.0.24-darwin-arm64.tar.gz` | Apple Silicon Mac |
| `remopilot-1.0.24-darwin-x64.tar.gz` | Intel Mac |

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

## Install from an archive

1. Download `remopilot-1.0.24-darwin-arm64.tar.gz` or `remopilot-1.0.24-darwin-x64.tar.gz` from the versioned Release.
2. Download `SHA256SUMS` from the same Release.
3. Verify and install:

```sh
shasum -a 256 -c SHA256SUMS
tar -xzf remopilot-1.0.24-darwin-arm64.tar.gz
sh install.sh
remopilot setup
```

Use the `x64` archive on an Intel Mac. The archive contains the signed CLI, the desktop helper, the native `RemoPilot.app`, the embedded Skills, manifests, publisher-signature data, dependency notices and the relinking material required by the bundled runtime license.

The installer verifies the publisher signature and the package layout before writing the managed installation. It does not overwrite an unrelated App, follow package symlinks or accept a package for another target. Existing configuration, pairing and permissions are retained.

## Pairing and permissions

When `setup` displays a machine code, open the pairing page yourself in a browser, sign in, enter that code on the computer and review the requested directories and capabilities. Do not send a pairing code to an assistant.

Grant only what you intend to use:

- Accessibility supports native app structure and input.
- Screen Recording is needed for app images and the separately enabled read-only desktop view.
- Project directory authorization is separate from terminal access. A readable terminal does not prove the background service can read the same directory.

The signed `RemoPilot.app` provides permission status and authorization entry points. Signing continuity cannot guarantee that macOS never asks again after an OS or permission change.

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

The versioned `v1.0.24` Release contains the two macOS archives and `SHA256SUMS`. Select the archive matching the Mac architecture and compare its SHA-256 with the corresponding line:

```sh
shasum -a 256 remopilot-1.0.24-darwin-arm64.tar.gz
```

Published version archives are not replaced. If a package is wrong, a new version is prepared with new checksums. The release feed, the cloud service, the machine agent and the home plugin are separate release surfaces; publishing this repository does not update an installed service.
