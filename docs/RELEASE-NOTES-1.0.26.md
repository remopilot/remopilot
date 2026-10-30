# RemoPilot 1.0.26 release notes

Version 1.0.26 is a macOS release for Apple Silicon and Intel Macs.

## Packages

| Target | Archive |
|---|---|
| `darwin-arm64` | `remopilot-1.0.26-darwin-arm64.tar.gz` |
| `darwin-x64` | `remopilot-1.0.26-darwin-x64.tar.gz` |

Both archives are Developer ID signed and notarized. The Apple Silicon package is signed, notarized and tested for installation and CLI startup. The Intel package has not yet been fully verified on a physical Intel Mac; check pairing, background-service permissions and cold-start behavior on the target machine.

Other platforms are not part of this release.

## Highlights

- The coordinated-wings icon and refreshed brand surface replace the previous mark across the Mac app, installer and plugin icons.
- The Mac app is now a console-style launcher. Background status, the installed window version, permission checks and the current connection are shown in one window, with numbered rows for Accessibility, Screen Recording, project-directory access, desktop control and command execution.
- Pairing starts inside the App. The six-digit code opens in its own window with a visible time limit and copy/open actions; generating a new code replaces the previous pending code instead of leaving both valid.
- Pairing recovery distinguishes superseded, cancelled and expired codes. A revoked machine can be paired again with its original machine credential, and an identity cannot be transferred to a different account.
- Permission checks use fresh probes. A foreground terminal result is not treated as proof that the background service can read the same project directory, and a check still in progress is not displayed as complete.
- Local macOS service updates remain direct. The running service is replaced in place, and tasks or gateway sessions interrupted by the switch are reported in the update receipt instead of being hidden.
- The reviewed user Skills were refreshed to match the current pairing, permission, app-entity and original-request recovery contracts.

## Fixes

- Pairing-code lifetime is bounded per surface, and code generation is rate-limited.
- A stale code cannot be reused after a newer code is generated, the attempt is cancelled, or the code expires.
- The launcher refreshes permission and capability labels after returning from System Settings, without presenting an unfinished probe as a completed check.
- The icon set, macOS `.icns` and plugin icons are generated from the coordinated-wings source rather than the previous artwork.

## Upgrade behavior

`brew upgrade` stages the next Cellar package. `remopilot homebrew --action install` verifies and activates it. Running tasks and gateway sessions are interrupted by the direct service switch; finish work that must not be interrupted before upgrading.

Existing configuration, pairing, machine identity, project authorization and permissions are retained. Activation does not log in, pair a machine or grant capabilities by itself. The update receipt reports the interrupted task and App-entity counts when they can be read; `null` means the value could not be read, not zero.

## Known limits

- Native app control requires macOS 14 or later, a usable desktop session and the permissions you grant.
- Terminal access does not prove that the background service can read the same project directory.
- The Intel package has not yet been fully verified on a physical Intel Mac. Browser pairing, background-service permissions and reboot/cold-start behavior are target-machine checks.
- The cloud service, machine agent, home plugin and this distribution repository are separate release surfaces. Updating one does not automatically update the others.
