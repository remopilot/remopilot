# Other devices and troubleshooting

device_run currently provides no Android or physical iPhone workflow. Android simulator inspection and interaction instead use the selected machine's Android CLI/ADB as described in [android-cli.md](android-cli.md); connected physical devices require the user's requested target and actual device authorization. Apple physical-device support in the Xcode MCP must be discovered and verified independently. Command execution does not prove device authorization, a signing identity, or a usable connection.

Inspect evidence from the earliest failed stage: original log tail and relevant errors for builds; actual device and package for installation; bundle/package ID, process, and crash logs for launch; current target app UI only for visual anomalies. Avoid repeatedly fetching the full environment, all devices, or complete logs.

Capturing or inspecting an existing app does not require rerunning the entire build-toolchain check. Retain required build SDK checks; do not eliminate errors by disabling signing, removing permission boundaries, or switching machines.

When runId/callId exists, query the original task first. Confirm it is terminal before changing build inputs. A retry must correspond to a concrete fix or new evidence. Verify actual state before retrying uncertain installations, launches, or other side effects.
