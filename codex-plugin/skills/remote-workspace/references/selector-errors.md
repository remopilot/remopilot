# Selector call failures

- An internal workspace_open error means only that this selector failed to open. A machine_list error means only that the list could not be read. Neither proves an empty selection, confirms a new directory, or authorizes another machine.
- Check the original connection and execution agent health, then retry at most once after recovery. If it still fails, stop unchanged retries and explain the blocker. Unspecified new targets remain pending selection; do not guess from recents or favorites.
- This chat's confirmed original bindingId, machine, and directory remain valid. A selector failure does not cancel tasks. Continue independent authorized work and recover original requests by original ID. Pause only work affected by actual binding or permission failures.
- Workspace selection remains the complete array confirmed in the selector. If the user explicitly names a machine and directory and requests immediate action, verify it with workspace_bind according to the real schema; do not claim this confirmed a selector change.
