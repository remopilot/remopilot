# App troubleshooting

Distinguish failure to create an independent instance, confirmed launch without readiness, unreadable windows, and unconfirmed action effects. Inspect only this entity's process, windows, and necessary logs; do not read the whole screen or other apps.

Launch with app_access(open) or app_run after verifying the execution machine's real `.app` path and isolation support. A successful shell launch establishes no entityId, ownership, or snapshots and does not replace managed access. Treat APP_INSTANCE_UNSUPPORTED and APP_DATA_ISOLATION_UNSUPPORTED as actual limitations; do not borrow the user's existing instance.

For not_ready, retain entityId and query status/observe on the same original process; a fresh observation may promote it to ready. Do not relaunch. Recover launch_unconfirmed through the original record instead of treating it as not started. See [app-entities.md](app-entities.md) for explicit disposition and cleanup.

For missing desktop capabilities, distinguish the agent switch, adapter, desktop session, Accessibility, and Screen Recording. AX reads and input do not require recording permission. app_capabilities is read-only; app_permissions requests system authorization and should follow the user's request. Do not reset TCC, start display services, or install another remote-control system to bypass restrictions. Use [remote-computer](../../remote-computer/SKILL.md) for machine-level issues.

Current app launch uses NSWorkspace and control uses Accessibility. It sends no Apple Events to the target app and uses no global event tap, Camera, or Microphone. Automation, Input Monitoring, Camera, and Microphone are not default requirements. Verify directory access separately for the binding; Full Disk Access is not a default requirement either. Terminal access does not prove background authorization. Local CLI directory checks require an actual project path, for example `remopilot permissions --permission directoryAccess --root /absolute/project`. Without a root, directory access is not probed and cannot report readiness. Check that same project through its actual background agent separately.

If a window is unreadable, verify the entity's original identity, actual error, and owned-window candidates. Do not send input after failed observation. A read-only user request does not authorize document edits to test effects. Delivered AXPress is not proof of business success. For uncertainty, query the original operationId/callId and inspect this entity's interface rather than clicking again.

