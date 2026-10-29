# Durable plans and workspace roles

## Workspace map and primary record machine

Maintain one concise map after selection and whenever it changes:

- Caller workspace: this conversation's environment and known local path. Its draft notes are not remote project evidence; do not invent host identity or treat unrelated files as disposable.
- Active targets: the exact machine/binding and authorized project path or explicit machine scope for each action. Parallel actions may have different targets.
- Connected workspaces: separately identified bindings and their intended roles. A connection does not authorize writes or execution everywhere.
- Primary record machine: one selected machine and existing binding holding the plan and cross-machine call index. This storage role is independent of the active executor.

Reuse an existing task's primary. For a new single-machine task, use its confirmed machine; for several machines, use the user's designation or the unambiguous main project machine and state the choice. If neither is clear, resolve it before dependent implementation; picker order and caller cwd are not storage policy.

Nonempty checkpoint bindingIds require state.workspaceMap with explicit primaryBindingId and workspaces=[{bindingId,role}]. Cover each binding exactly once. Roles are general, reference, development, build, verification or output; primary and activeBindingIds must belong to that set. Save caller={label,path?} when known. A saved active list describes the plan, not live execution or permission. Local unscoped checkpoints may have empty bindingIds; hosted checkpoints need at least one binding for machine-side content storage. A session itself may begin before target selection.

## Persist before implementation

Once targets are confirmed, save goal, mapping, steps/dependencies, constraints, acceptance criteria, completed work, open issues and next action. Save visible decisions, not private reasoning. Discovery may precede the plan.

Use context_checkpoint with the task sessionId, explicit bindingIds, a stable requestKey and the current expectedRevision. Before any execution, runs=[]. Use state.summary/decisions/nextSteps for the plan, constraints for acceptance criteria, and completed/unresolved for actual progress. Retain original run references and sourceHandoffId on later saves. Resume and merge on a revision conflict. An uncertain save is retried with identical arguments/key rather than replaced with a fresh summary.

Verify returned storage. The cloud saves the body on explicit state.workspaceMap.primaryBindingId; it keeps only an index. There is no first-binding fallback. Keep the complete binding set and actual storage pointer. Local relay SQLite is on the relay host, which may differ from the execution machine. If it does not establish target-side persistence, save an authoritative note through manage_context on an already authorized project binding and read it back. Discover that tool's schema first: checkpoints replace its document, so merge existing entries and use its own expectedRevision/idempotencyKey, distinct from the outer requestKey. Restore paginated entries as needed. Never invent a project for a machine binding or fabricate verified references/file hashes.

If supported target persistence is unavailable, report the gap and defer implementation dependent on an unsaved plan change. Original-ID recovery and independent authorized work may continue. Do not silently replace an offline primary. An intentional primary change requires saving and reading the new plan and preserving old storage/execution links; it does not transfer live work.

## Progress, evidence and continuity

Save revised plans before dependent actions, at material milestones and before deliberate handoff. Serialize checkpoint writes to avoid revision conflicts; parallel calls keep individual receipts. Do not checkpoint every read-only query.

The primary index retains each action's original machine/binding, request/run/call IDs, verified result or uncertainty, and log/artifact recovery reference. Original evidence stays on each executor. Summaries are bounded and explicit; they neither replicate all journals nor archive every external file or screenshot. Label missing/truncated evidence and do not copy secrets or full logs into state.

Keep a concise user-visible recovery pointer: sessionId/taskId, latest handoffId, returned taskUrl, primary machine and storage/note reference. A failed save is not a saved plan. On interruption, restore the session/checkpoint or target note, read newer events and original execution state before resuming. An empty caller workspace does not justify recreating the task or replaying it. See [context.md](../../remote-context/references/context.md) for storage limits and history.

A taskUrl opens the account-authenticated latest-task page; a handoffId names an immutable snapshot. Neither dispatches work, transfers host transcripts or carries temporary grants. Local links need existing authentication and network access. A missing/offline storage machine means unavailable plan content, not an empty plan or permission to infer success.
