# RemoPilot Homebrew Tap

The Formula in `Formula/remopilot.rb` selects the macOS archive for the current Mac:

| Mac | Target |
|---|---|
| Apple Silicon | `darwin-arm64` |
| Intel | `darwin-x64` |

Version `1.0.24` does not include Linux or Windows packages.

## Install

```sh
brew tap --custom-remote remopilot/remopilot https://github.com/remopilot/remopilot.git
brew install remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot setup
```

`brew install` downloads the signed archive into Cellar and writes a launcher. The explicit activation step verifies the package again, retains it outside Cellar and uses the normal RemoPilot installer. On a new machine, `setup` starts browser pairing. On an existing machine, keep the current configuration and pairing instead of pairing again.

The Formula preserves the signed program bytes and the required dependency and relinking materials. No source checkout, Bun, npm or Node is required on the user's machine.

## Upgrade

```sh
brew update
brew upgrade remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot version
remopilot status
```

macOS managed services use a direct update. Running tasks and gateway sessions are interrupted while the service is replaced; the update receipt reports the affected count when readable. Do not force an upgrade when a task must finish without interruption.

`brew upgrade` updates only the Cellar candidate and launcher. Activation switches the managed installation. Managed programs, generation data and machine configuration stay outside Cellar and survive `brew cleanup` or `brew uninstall`. Use RemoPilot service management rather than `brew services`.

## Archive fallback

If Homebrew is unavailable, download the archive matching the Mac and its `SHA256SUMS`, verify the checksum and run `install.sh` from the extracted package. See [installation and verification](INSTALLATION.md).

## Scope

This repository contains the Formula and user-facing documentation. It does not contain product source code. Publishing this repository does not make the product source open source, publish an older version or update an already installed service.
