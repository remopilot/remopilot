---
name: remote-mobile
description: Use RemoPilot to build, install and run an explicitly selected iOS project in iOS Simulator on a paired Mac with Xcode, capture simulator evidence and diagnose failures. The managed device_run workflow does not currently support Android or physical iPhones.
---

# Remote mobile projects

Use the [core calling contract](../remote-workspace/references/calls.md) once per task and target version. Before implementation, follow the [planning contract](../remote-workspace/references/planning.md). Existing execution recovery need not wait for reloading skills.

Use this skill for running and validating mobile projects; use remote-development for source edits. Local devices are not devices on the bound machine.

1. Confirm the machine, project, and target device. In a monorepo, locate the actual mobile project first. device_run must bind to that project directory and does not accept workDir. Use outer workDir only for run_command/run_pipeline in a subdirectory.
2. Verify device and tool capabilities through the current machine catalog. Currently device_run supports only iOS Simulator; do not claim other platforms are supported.
3. Verify actual results for build, installation, and launch separately. Retain the original requestId/runId for long tasks. Runner results require MCP structuredContent and execution.version=1; recovery must match the original runId and consistent status/unfinished/closureUnknown target fields. On timeout or uncertain state, query the original task rather than rerunning with another key. device_run waitMs accepts at most 60,000 milliseconds.
4. For requested screenshots, identify the device and foreground app, capture the device display first, and inspect the image before delivery. A system desktop, launch screen, or existing screenshot file is not proof that the app is running.

Read only references needed for the task:

- iOS Simulator build, launch, or capture: [ios-simulator.md](references/ios-simulator.md).
- Android, physical iPhone, or build/launch failures: [devices-and-failures.md](references/devices-and-failures.md).
- Disconnection, uncertain results, or recovery: [recovery.md](../remote-workspace/references/recovery.md).
- Discovery differences across service versions: [calls.md](../remote-workspace/references/calls.md).

Distinguish successful build, actual execution, visual inspection, interaction verification, and backend verification. Do not close existing user instances. Clean up self-created instances through the managed workflow only after every original stage run is confirmed ended, obtaining required screenshots first. An unknown closure retains the instance and its recovery record; keep querying the original ID. Do not report a closed instance as still available for viewing.

Use the target machine’s existing SDK executables. RemoPilot does not provision or manage a Flutter SDK pool.
