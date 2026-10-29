---
name: remote-context
description: Persist and update a RemoPilot task plan, save progress and execution references, or resume a task from its session or handoff. Use for continuity across interruptions and chats, including latest-task links.
---

# Persist plans and resume tasks

Use the [core calling contract](../remote-workspace/references/calls.md) once per task and target version. Read [planning.md](../remote-workspace/references/planning.md) when saving the initial plan or changing its target/storage mapping, and [context.md](references/context.md) for snapshots and history.

- After target confirmation, save the actionable plan before implementation. Update it for plan changes, material milestones and handoff. Keep one primary record machine and original execution references per target; caller-local notes must not be the only recovery copy.
- Every scoped checkpoint needs explicit bindingIds and state.workspaceMap with primaryBindingId and one role per binding. There is no first-binding or text fallback. Verify returned storage; local relay SQLite is not necessarily storage on the execution machine.
- Include sessionId and the current expectedRevision. On REVISION_CONFLICT, resume and merge before writing. Save visible goals, constraints, decisions, verified results, unresolved issues and next steps; do not store private reasoning, credentials or full logs.
- Keep actual original IDs in runs and sourceHandoffId when continuing a summary. Recover an uncertain save with identical arguments and requestKey. A successful receipt establishes the returned storage; an attempted save does not.
- Resume with session_manage(resume) and review blockingReview/nextAction before relying on saved steps. Read newer events incrementally through a fixed throughSequence, and inspect original runs/calls and relevant files. Use context_restore(handoffId) for an explicitly requested immutable prior snapshot.
- Record user requirements that did not pass through execution tools with session_manage(append). This is explicit capture, not automatic preservation of the host chat.

Retain session/task/handoff IDs, the actual storage machine/reference, machine names, binding IDs and real project paths in the user-facing recovery pointer. A machine binding has no invented project path. Cloud content restoration requires the primary storage machine online. A returned taskUrl opens the authenticated latest-task page; it does not execute work, import chat history or inherit temporary grants. A handoff is a versioned snapshot, not the latest-task link.

Restoration grants no new permission and never justifies replay. In a new chat, re-establish any temporary access as required. If the storage machine is unavailable, preserve the recovery pointers and report the missing plan; original-ID recovery on accessible executors may continue. The plugin cannot clear host context, measure exact host token usage or create/wake a chat without an actual host capability.
