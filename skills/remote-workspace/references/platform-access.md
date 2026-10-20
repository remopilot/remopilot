# macOS directory permissions

DIRECTORY_ACCESS_DENIED means the OS denied access; DIRECTORY_ACCESS_TIMEOUT means a bounded probe did not return and may also indicate an unavailable filesystem. Neither alone establishes that Full Disk Access is required. Inspect the returned runtime path to identify the actual permission subject. Terminal access does not prove the background service can read a project.

For user-authorized permission troubleshooting, use the actual background-service directory probe and let the user approve any system dialog manually. `remopilot permissions --root PATH --open-settings` actively checks the selected path and opens the relevant settings. The RemoPilot App can also request directory access or open privacy settings. Do not click consent, edit/copy TCC state, or assume a familiar name or signing identity establishes access.

After authorization, recheck the original binding with workspace_tools. No new binding, lock removal or business-task restart is needed. Diagnose an old generation against its original runtime path, not a new executable. A failed permission probe does not prove the original task failed; recover that task by original ID. If recovery is also blocked, report the limitation without changing bindings to bypass it.

A timeout while consent is pending remains uncertain until the original probe is confirmed ended. Before retrying an original mutation, require explicit non-execution evidence and current authorization; keep its original idempotencyKey when the contract permits a new request. Closing the App window does not establish that the background service stopped. Installation, service activation and actual background directory access require separate evidence.
