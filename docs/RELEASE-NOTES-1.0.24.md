# RemoPilot 1.0.24 release notes

Version 1.0.24 is a macOS release for Apple Silicon and Intel Macs.

## Packages

| Target | Archive |
|---|---|
| `darwin-arm64` | `remopilot-1.0.24-darwin-arm64.tar.gz` |
| `darwin-x64` | `remopilot-1.0.24-darwin-x64.tar.gz` |

Both archives are Developer ID signed and notarized. The Apple Silicon package is signed, notarized and tested for installation and CLI startup. The Intel package has not yet been fully verified on a physical Intel Mac; check pairing, background-service permissions and cold-start behavior on the target machine.

Other platforms are not part of this release.

## Changes

- Local macOS service updates are direct. The running service is replaced in place, and tasks or gateway sessions interrupted by the switch are reported in the update receipt instead of being hidden.
- The native RemoPilot app exposes permission status and entry points for Accessibility, Screen Recording and project directory access, plus owner actions for desktop control and command execution.
- App entities keep explicit ownership, recovery and cleanup rules for supported macOS applications.
- Background work keeps original request IDs, execution evidence and receipt state for recovery after a disconnect or update.
- Multi-machine work uses explicit workspace, Git, resource and machine coordination declarations.
- The reviewed user Skills were refreshed to match the current client workflow and tool contract.

## Upgrade behavior

`brew upgrade` stages the next Cellar package. `remopilot homebrew --action install` verifies and activates it. Running tasks and gateway sessions are interrupted by the direct service switch; finish work that must not be interrupted before upgrading.

Existing configuration, pairing, machine identity, project authorization and permissions are retained. Activation does not log in, pair a machine or grant capabilities by itself.

## Known limits

- Native app control requires macOS 14 or later, a usable desktop session and the permissions you grant.
- Terminal access does not prove that the background service can read the same project directory.
- The Intel package has not yet been fully verified on a physical Intel Mac. Browser pairing, background-service permissions and reboot/cold-start behavior are target-machine checks.
- The cloud service, machine agent, home plugin and this distribution repository are separate release surfaces.
