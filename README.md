# RemoPilot

RemoPilot connects ChatGPT and Codex to computers you pair yourself. From one conversation you can work with an authorized project or machine, run its existing tools, follow long-running work, recover the original request after a disconnect, and operate supported macOS applications in an owned background instance.

<p align="center">
  <a href="https://remopilot.com"><strong>Website</strong></a> ·
  <a href="https://github.com/remopilot/remopilot/releases/tag/v1.0.24">Latest release</a> ·
  <a href="docs/INSTALLATION.md">Install</a> ·
  <a href="docs/HOMEBREW.md">Homebrew</a>
</p>

## This repository

This is the public distribution surface for RemoPilot. It contains:

- reviewed user Skills
- installation and upgrade guides
- the Homebrew Formula
- release notes

It does **not** contain product source code, build scripts, release credentials, machine data, logs, or development history. The product source remains private and is not licensed under the repository license. The documentation, user Skills, Homebrew Formula and installer scripts in this repository are licensed under Apache-2.0; see [License](#license).

## Current release

Version `1.0.24` provides macOS packages for:

| Target | Machine | Package |
|---|---|---|
| `darwin-arm64` | Apple Silicon Mac | `remopilot-1.0.24-darwin-arm64.tar.gz` |
| `darwin-x64` | Intel Mac | `remopilot-1.0.24-darwin-x64.tar.gz` |

Other platforms are not part of this release. Do not install a package for another platform or reuse an older archive for this version.

The Intel package has not yet been fully verified on a physical Intel Mac. Check browser pairing, background-service permissions and cold-start behavior on the target machine before relying on it.

## Requirements

- macOS 14 or later
- An Apple Silicon or Intel Mac
- Homebrew, if you use the Homebrew installation path
- A RemoPilot account and a machine you pair yourself
- The system permissions you choose to grant for Accessibility, Screen Recording and project directory access

Native app control requires a usable desktop session. Terminal access does not prove that the background service can read the same directory.

## Install with Homebrew

```sh
brew tap --custom-remote remopilot/remopilot https://github.com/remopilot/remopilot.git
brew install remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot setup
```

`brew install` places the signed package in Cellar and installs a launcher. The explicit activation step verifies the package again, retains it outside Cellar and uses the normal RemoPilot installer.

On a new machine, `setup` starts browser pairing and lets you approve only the directories and capabilities you intend to use. Existing configuration, pairing and permissions are retained during an upgrade.

## Install from an archive

Download the archive matching the Mac and `SHA256SUMS` from the versioned Release, then verify and install:

```sh
shasum -a 256 -c SHA256SUMS
tar -xzf remopilot-1.0.24-darwin-arm64.tar.gz
sh install.sh
remopilot setup
```

Use the `x64` archive on an Intel Mac. The installer verifies the publisher signature and package layout before changing the managed installation. It does not overwrite an unrelated App, follow package symlinks or accept a package for another target.

### Bootstrap script

The repository also provides a small bootstrap script that selects the matching archive, verifies `SHA256SUMS` and runs the package installer:

```sh
curl -fsSL https://raw.githubusercontent.com/remopilot/remopilot/main/install.sh -o install.sh
less install.sh
sh install.sh
```

Review the script before running it. It downloads the signed release archive and does not build from source. To verify the download and checksum without installing, run `sh install.sh --dry-run`. The manual archive steps above remain available if you prefer to verify and extract the package yourself.

## Upgrade

```sh
brew update
brew upgrade remopilot/remopilot/remopilot
remopilot homebrew --action install
remopilot version
remopilot status
```

macOS managed services use a direct update. Tasks and gateway sessions that are running during the switch are interrupted; the update receipt reports the affected count when it can be read. Do not start an upgrade while work must finish uninterrupted.

`brew cleanup` or `brew uninstall` removes only the Cellar package and launcher. Managed programs, generations and machine data remain outside Cellar. Use RemoPilot's service commands rather than `brew services`.

## What is included

| Area | Purpose |
|---|---|
| Project files | Search, read, edit and move files inside an authorized project |
| Commands and background tasks | Run the machine's existing tools, follow progress and recover the original request |
| Multi-machine coordination | Work on independent machines in parallel with explicit shared-resource declarations |
| Native macOS App control | Observe owned app windows, read accessibility elements and perform requested actions |
| iOS Simulator | Build, install and run a project in Simulator on a paired Mac with Xcode |
| Durable context | Save a plan and hand work to a later conversation with original execution references |

Exact tool names, input schemas and permissions come from the installed machine catalog and the current MCP definitions. A Skill can describe a capability that the selected machine has not enabled, or that an older installed package does not provide.

## User Skills

| Skill | Purpose |
|---|---|
| [remote-workspace](skills/remote-workspace/SKILL.md) | Select paired computers, authorized projects and bindings |
| [remote-computer](skills/remote-computer/SKILL.md) | Machine connectivity, capabilities, diagnostics and commands |
| [remote-development](skills/remote-development/SKILL.md) | Project files, development commands and Git |
| [remote-tasks](skills/remote-tasks/SKILL.md) | Background work and original-request recovery |
| [remote-coordination](skills/remote-coordination/SKILL.md) | Independent work across selected machines |
| [remote-context](skills/remote-context/SKILL.md) | Durable task summaries and handoff |
| [remote-app](skills/remote-app/SKILL.md) | Supported installed macOS apps in owned instances |
| [remote-mobile](skills/remote-mobile/SKILL.md) | iOS Simulator work on a paired Mac |

Skills require an authenticated RemoPilot connection and a paired machine. Downloading these Markdown files does not grant access, install a server or authorize a project directory.

## Claude plugin

[`claude-plugin/`](claude-plugin/README.md) is the Claude Code plugin bundle for Anthropic's plugin directory. It contains its own manifest, the remote MCP connection to `https://app.remopilot.com/claude/mcp`, eight skills with their reference documents, a README, and license files. Its independent version is `1.3.6`; it does not follow the machine runtime version above.

The bundle contains no hooks, executable files, credentials or product source. Skill bodies ship inside the folder, so installing the plugin does not download behavioral instructions. Installing the plugin does not install the runtime: pair a computer first, then complete the plugin's OAuth sign-in.

Each host keeps its own sibling folder, such as a future `codex-plugin/`, because manifests, connection files and skill packaging differ by host.

## Privacy and security

- This repository contains only user-facing Skills, their referenced instructions, the Claude plugin bundle, the Homebrew Formula and installation documentation.
- Installation archives contain the signed programs, embedded Skills, dependency notices and the relinking material required by the bundled runtime license. They do not contain product source, build scripts, credentials, logs, machine data or private Git history.
- The official cloud service, the machine agent, the home plugin and this repository are separate release surfaces. Updating one does not automatically update the others.
- Keep credentials in the machine's private configuration. Never paste access tokens, pairing codes or private keys into chat, documentation or issue reports.

## Documentation

- [Installation and verification](docs/INSTALLATION.md)
- [Homebrew guide](docs/HOMEBREW.md)
- [Release notes](docs/RELEASE-NOTES-1.0.24.md)

## License

The documentation, user Skills, Homebrew Formula and installer scripts in this repository are licensed under the [Apache License 2.0](LICENSE).

The RemoPilot name, logo, product binaries and product source are **not** licensed under Apache-2.0. See [TRADEMARK.md](TRADEMARK.md) for brand-use rules. The signed installation archives remain subject to the terms and third-party notices included with each release.
