# Entity lifecycle and recovery

This reference ships with the plugin. Always use that machine’s current tool schema.

## Creation and readiness

app_access(open) and app_run create a separate background process from a real absolute `.app` path (macOS) or `.exe` path (Windows). The default isolation=strict requires a supported independent profile contract; Chromium apps currently support dedicated user-data-dir profiles. Unsupported apps return APP_DATA_ISOLATION_UNSUPPORTED. Use isolation=process only when the user accepts process isolation with shared app data. If multiple instances are unsupported, APP_INSTANCE_UNSUPPORTED preserves the user's original instance.

open binds the entity to the original process identity and checks its window readiness. It cannot follow a replacement process; launch completion and window readiness are separate evidence.

- ready: retain entityId and continue observe/act/run on that entity.
- not_ready: launch was confirmed but the window has not passed readiness checks. The error receipt retains the instance/entity and helper. Query status or observe the original entityId; a successful fresh observation can promote it to ready. Do not relaunch.
- launch_unconfirmed: launch may have been dispatched, but identity or receipt is uncertain. Preserve entityId, callId, and records. Do not repeat open, guess a PID, kill processes, or clear locks.
- not_started or explicit executed=false: only the corresponding action was not dispatched. Review the error and current authorization before submitting a corrected action; other accepted requests remain unaffected.

`resolveLaunch(entityId, resolution="preserve", reason)` applies only to the original caller's unowned launch_unconfirmed record. It explicitly abandons management while preserving the external process: it releases that record's management lease and records launch_abandoned plus the review reason. It does not terminate an app, prove non-execution, or confirm business success. Use it only when the user explicitly chooses this disposition, never as automatic unlocking before a retry.

## Ownership, windows, and snapshots

owner comes from the authenticated binding/session/caller and cannot be overridden. Retain all three identities. Trusted requests by the same caller/session on another project can renew the lease, but cannot control the entity across bindings. list exposes only peer existence; app_targets returns live windowId values controllable by this caller.

observe captures this entity's exact window with tree/elements/image/both. For multiple windows, verify owned-window candidates and pass the exact windowId instead of choosing the first. act accepts only a fresh snapshot from the same entity, elementId, and press/setValue/type; key and typeText post background key or Unicode events to the owned PID when an App canvas exposes no settable AX text. Text goes first to a settable field: setValue/type, or typeText with that elementId (appends via AXValue, via=setValue, no focus change). Real keystrokes (typeText on a canvas, plain keys) need the owned App frontmost and are refused with APP_NOT_FRONTMOST (nothing sent, backgroundTextTargets listed) otherwise; activate returns frontmost=true once it is and invalidates older snapshots. activate brings the owned App to the front and changes the user's current focus; use it only when setValue/type and background key had no effect, and expect physical keyboard input to reach that App while frontmost. Save, send and delete actions require explicit user intent; clickAt/drag/scroll use point coordinates relative to the observed window's top-left; menu takes an exact title path; pointer delivery is unverified, so observe again. observe returns overlays (other-process windows above the target) and pointer actions under one are refused with FOREIGN_OVERLAY_COVERS_TARGET. cmd+Q and force-quit shortcuts and Quit menu items are refused; cmd+W and delete shortcuts are not blocked, so they need explicit user intent. observe returns dialogs (owned sheets and dialogs with texts and button titles) and otherWindows; app_access(answerDialog, button) presses one exact button without a snapshot, only when the user asked for that answer. close and status surface a pending Save prompt and keep the entity controllable. typeText in the background tries accessibility insertion at the focused element (via=axSelectedText), then clipboard=true (background paste with the clipboard restored) or borrowFocus=true (about 250 ms of front, handed back); password fields are refused. answerDialog rescans and reports stillPresent; prompts are surfaced even when the App has no window. open starts a focus guard so the user's front App is restored if the launched App or its updater takes the front. app_access(requestHelp, message, optional title/placement/windowId) asks the user for help without taking focus: local notification, AXRaise inside the App, optional layout, and the AI cursor at the window; it returns notified/placed/raised/frontmost and focusChanged=false. The AI cursor is a click-through display overlay that glides to the operated point (REMOPILOT_AI_CURSOR=0 hides it); it never moves the real pointer or changes permissions. layout places the observed window in the left or right half, center or full area of the main display. desktop_view (separate screen-view opt-in) returns a read-only whole main-display image with no element IDs, snapshots or coordinates and never creates an action target. Input invalidates other old snapshots for that process; observe before another input. Entity run forbids appTarget overrides; one-shot app_run selects its own managed process and does not accept per-step target overrides.

Use app_access/app_run for owned App operations. Entity ownership is supplied by the authenticated machine agent: the host conversation identity when available, otherwise the authenticated task session. Never put an owner or controller into tool arguments. The public catalog does not expose whole-desktop reads, coordinate clicks or foreground keyboard/mouse input. AX input requires Accessibility; images additionally need Screen Recording. Check permissions and directory access separately.

Visual capture grants no cross-entity control and does not replace a fresh snapshot for input. An independent profile does not isolate arbitrary documents, keychains, network services, or other OS user processes. Declare consistent resources for shared documents, databases, caches, and outputs.

## Operation receipts

Retain the returned operationId, original callId/workflow and fixed target. The tool persists operation identity; do not invent it or duplicate its journal. A wait timeout ends observation only; it does not prove input ended. Read the original receipt with app_access(recover, entityId, operationId) or app_operation(entityId, operationId); recover original gateway calls/runs through manage_call/manage_run.

For a terminal receipt whose effect remains unverified, inspect the entity's actual interface instead of clicking again. Missing receipts do not prove non-execution; helper death does not trigger automatic restart/replay. If the PID is reused, end the original entity record and preserve the replacement process; do not take over its new identity.

## Finish and cleanup

release normally closes the app created for the task gracefully. Set retain=true only for explicit retention; retained entities are not automatically reclaimed. close explicitly closes an entity. detach releases project ownership and starts a grace period; it is not confirmed closure.

Lease expiry or a cleanup attempt is not confirmed closure. Cleanup requires the machine online, original identity verifiable and graceful exit unblocked. Offline state, sleep, missing permissions, unsaved-data prompts, or uncertain input retain retained/close_pending with evidence. Do not force-kill or remove locks. A retained app's helper may exit; later access must verify original process identity before reclaiming it.

Confirm closure, business effects, and input terminal state separately. Report retained entityId, operationId/callId, original binding, and blockers. Unfinished entities and receipts in an old generation remain recoverable there; do not migrate or replay them.

## Windows

The Windows adapter keeps this lifecycle (open, observe, act, release, recover) and the same receipts. What differs:

- Launch: the helper starts the executable with CreateProcess, unactivated, with none of its own handles inherited. A Windows executable has no bundle identifier, so its file name stands in for it: chrome.exe, chromium.exe, msedge.exe and brave.exe get the private user-data-dir profile; any other App needs isolation=process. An executable that hands off to an already running instance exits at once and is reported as APP_INSTANCE_UNSUPPORTED; the user's instance is never adopted.
- Identity: PID plus the process creation time, and the executable path compared case-insensitively. Ownership is an exclusive file open that no second helper can obtain (APP_ENTITY_IN_USE).
- Elevation: a normal-integrity helper cannot observe or control an administrator App (UIPI). claim refuses it with ELEVATED_TARGET_UNSUPPORTED before anything is sent.
- Observation: a bounded UI Automation tree. Element ids, isValueSettable and password handling match the macOS contract; a password field's value is never returned and never written. Window geometry is in physical pixels (unit "pixels"), and images are PNG of the visible frame, produced by asking the window to paint itself, so another window covering it does not appear in the image.
- Dialogs: visible dialogs and owned pop-ups of the App are listed with texts and button titles, and answerDialog presses one by exact title or "[Close window]". Prompts of other processes are not read or answered on Windows.
- Delivery: posted keys and pointer events are delivered, not confirmed; a value readback is the only confirmed effect. Treat an unverified result as unknown and observe again.
- Close: release sends WM_CLOSE to the App's windows, so an App with unsaved work shows its own prompt; nothing is force-killed.

### Dedicated virtual desktop

The machine owner chooses where the AI's windows go with `remopilot configure --app-desktop virtual|current` (default current; needs desktop control). With virtual, the helper creates (or reuses) a desktop named `RemoPilot` or `RemoPilot · <desktopLabel>` and moves every window the launched App opens onto it, once per window, so the user's work is not disturbed and the user can switch there (Win+Tab) to log in or help. The interface Windows offers for this is undocumented and build-specific (Windows 11 24H2, build 26100.2605 or later). When it is missing or fails, the App starts on the current desktop and the entity's `desktop.fallback` names the reason; nothing is retried silently. A brief appearance on the user's desktop before the move is possible. Closing the last entity removes only a RemoPilot-named desktop that holds no windows and is not the one the user is on. The model must not change the setting, switch desktops or move windows between desktops.
