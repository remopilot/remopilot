# Targeted observation

First create this caller's exclusive entity with app_access(open, appPath). appPath must be a real absolute `.app` path on the execution machine; do not borrow the user's open process. Retain original bindingId, sessionId, and entityId for all observation and actions.

- Text, menus, and controls: use app_access(observe, entityId, mode="tree"/"elements"). Limit scope with fields supported by the current schema, not old screen-tool parameters.
- Visual layout or image delivery: mode="image"/"both" captures only this entity's exact window. Current app_access accepts no ROI, coordinates, app_target, or window_id.
- Multiple windows: verify a controllable live windowId from app_targets or owned-window candidates from APP_TARGET_AMBIGUOUS, then observe with windowId. Peer information grants no observation rights; do not choose the first entry blindly.
- One window screenshot is neither a full document read nor necessarily just its body. Locate a requested page and its visible region first; do not infer unseen content.
- Read-only observation may overlap independent background work but is not a consistent snapshot during app changes. Interact with a fresh snapshot and elementId from the same entity or through managed app_run. Never reuse another instance's windows or snapshots.
- Display actual artifact/image content. For a remote path alone, verify client access or use the exposed artifact reader; do not present it as a local clickable file.

Use browser capabilities actually available and authorized on the same machine for web content. Without browser-specific tools, do not invent DOM access or global screen/input capabilities.

Normally omit read_artifact.maxBytes/responseMaxBytes for screenshots. Images have a default maximum of 5 MiB; oversized PNG/JPEG images are proportionally reduced with a compression notice, preserving originals. responseMaxBytes governs text/queries. Read actual bytes rather than inferring size from budget errors. Compressed images are for viewing and delivery, not coordinate input; app actions still need the original entity's fresh snapshot and elementId.
