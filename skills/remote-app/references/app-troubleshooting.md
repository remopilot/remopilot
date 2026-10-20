# App troubleshooting

Distinguish failure to create an independent instance, confirmed launch without readiness, unreadable windows, and unconfirmed action effects. Inspect only this entity's process, windows, and necessary logs; do not read the whole screen or other apps.

Launch with app_access(open) or app_run after verifying the execution machine's real `.app` path and isolation support. A successful shell launch establishes no entityId, ownership, or snapshots and does not replace managed access. Treat APP_INSTANCE_UNSUPPORTED and APP_DATA_ISOLATION_UNSUPPORTED as actual limitations; do not borrow the user's existing instance.

For not_ready, retain entityId and query status/observe on the same original process; a fresh observation may promote it to ready. Do not relaunch. Recover launch_unconfirmed through the original record instead of treating it as not started. See [app-entities.md](app-entities.md) for explicit disposition and cleanup.

For missing desktop capabilities, distinguish the agent switch, adapter, desktop session, Accessibility, and Screen Recording. AX reads and input do not require recording permission. app_capabilities is read-only; app_permissions requests system authorization and should follow the user's request. Do not reset TCC, start display services, or install another remote-control system to bypass restrictions. Use [remote-computer](../../remote-computer/SKILL.md) for machine-level issues.

Current app launch uses NSWorkspace and control uses Accessibility. It sends no Apple Events to the target app and uses no global event tap, Camera, or Microphone. Automation, Input Monitoring, Camera, and Microphone are not default requirements. Verify directory access separately for the binding; Full Disk Access is not a default requirement either. Terminal access does not prove background authorization. Local CLI directory checks require an actual project path, for example `remopilot permissions --permission directoryAccess --root /absolute/project`. Without a root, directory access is not probed and cannot report readiness. Check that same project through its actual background agent separately.

If a window is unreadable, verify the entity's original identity, actual error, and owned-window candidates. Do not send input after failed observation. A read-only user request does not authorize document edits to test effects. Delivered AXPress is not proof of business success. For uncertainty, query the original operationId/callId and inspect this entity's interface rather than clicking again.

## Windows

- ELEVATED_TARGET_UNSUPPORTED: the App runs as administrator and a normal helper cannot reach it. Do not retry; ask the user to start it normally or operate it themselves. UAC and other secure-desktop prompts are never visible to the helper.
- ACTIVATE_WOULD_SWITCH_DESKTOP: the App's window is on its own virtual desktop. Use requestHelp so the user can switch when ready; do not try another focus path.
- desktop.fallback on an entity (VIRTUAL_DESKTOP_UNAVAILABLE or VIRTUAL_DESKTOP_FAILED): the machine asked for a dedicated desktop but this Windows build or call did not allow it. The App is on the user's current desktop; tell the user and continue only if that is acceptable.
- APP_NOT_FRONTMOST: the focused control reads real input state and the App is not in front, so nothing was sent. Prefer setValue on a settable field, then clipboard=true, then borrowFocus=true.
- CLIPBOARD_NOT_RESTORABLE: the clipboard holds non-text content that a paste could not restore, so nothing was pasted.
- A locked screen or a disconnected remote session can leave windows unpaintable (CAPTURE_FAILED) while accessibility still answers; report it instead of retrying input.
- Windows has no permission prompts for this adapter: app_permissions only reports that. Failures are integrity levels, session state or the App's own accessibility support, not missing grants.
