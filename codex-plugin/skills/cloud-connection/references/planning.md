# Durable plans and workspace roles

Answer simple questions directly; do not create a session, project journal or checkpoint solely for the answer. Read the project instructions and files when needed and honor an explicit request to preserve the answer.

## Workspace map and primary record machine

Maintain one concise map after selection and whenever it changes:

- Caller workspace: this conversation's environment and known local path. Its draft notes are not remote project evidence; do not invent host identity or treat unrelated files as disposable.
- Active targets: the exact machine/binding and authorized project path or explicit machine scope for each action. Parallel actions may have different targets.
- Connected workspaces: separately identified bindings and their intended roles. A connection does not authorize writes or execution everywhere.
- Primary record machine: one selected machine and existing binding holding the plan and cross-machine call index. This storage role is independent of the active executor.

Reuse an existing task's primary. For a new single-machine task, use its confirmed machine; for several machines, use the user's designation or the unambiguous main project machine and state the choice. If neither is clear, resolve it before dependent implementation; picker order and caller cwd are not storage policy.

Nonempty checkpoint bindingIds require state.workspaceMap with explicit primaryBindingId and workspaces=[{bindingId,role}]. Cover each binding exactly once. Roles are general, reference, development, build, verification or output; primary and activeBindingIds must belong to that set. Save caller={label,path?} when known. A saved active list describes the plan, not live execution or permission. Local unscoped checkpoints may have empty bindingIds; hosted checkpoints need at least one binding for machine-side content storage. A session itself may begin before target selection.

## Persist when the host determines it is needed

Once targets are confirmed for project work, read the project's applicable instructions first. For requested resumption find the latest unfinished journal first. For ongoing authorized project work, the host decides when to open the journal and promptly synchronize the plan, progress, completed work, blockers and next steps to `PROCESS.md` in accordance with user and project instructions; follow [project-journal.md](project-journal.md). Preserve the original session ID and journal path. Save visible decisions, not private reasoning. Discovery may precede the plan. Respect explicit read-only constraints; do not write merely because a folder was selected.

When a durable checkpoint is needed, use task_update(checkpoint) with the task sessionId, explicit bindingIds, a stable requestKey and the current expectedRevision. Before any execution, runs=[]. Use state.summary/decisions/nextSteps for the plan, constraints for acceptance criteria, and completed/unresolved for actual progress. Retain original run references and sourceHandoffId on later saves. Resume and merge on a revision conflict. An uncertain save is retried with identical arguments/key rather than replaced with a fresh summary.

Verify returned storage. The cloud saves the checkpoint body on explicit state.workspaceMap.primaryBindingId; it keeps only an index. There is no first-binding fallback. Keep the complete binding set and actual storage pointer. Local relay SQLite is on the relay host, which may differ from the execution machine. Project journal files are separately saved and read back on each selected project machine; the checkpoint is a recovery index and desktop snapshot, not an automatic file mirror. Machine-only tasks keep their supported checkpoint and original IDs without inventing a project path. Never fabricate verified references or file hashes.

If needed target persistence is unavailable, report the gap and follow the user and project instructions for dependent work. Original-ID recovery and independent authorized work may continue. Do not silently replace an offline primary. An intentional primary change requires saving and reading the new plan and preserving old storage/execution links; it does not transfer live work.

## Progress, evidence and continuity

Keep PROCESS.md current during execution: promptly save meaningful progress, completed steps, changes and blockers; record original execution IDs before a long wait or handoff, then update the outcome when known. Do not wait for host compaction. The host decides when to save revised plans and separate checkpoints according to the task and project instructions. Serialize writes and merge current files or checkpoint revisions to avoid lost updates; parallel calls keep individual receipts. Do not checkpoint every read-only query.

The primary index retains each action's original machine/binding, request/run/call IDs, verified result or uncertainty, and log/artifact recovery reference. Original evidence stays on each executor. Eligible new redacted call records can also queue for asynchronous synchronization to the explicitly selected primary machine; check actual availability and pending status rather than assuming the copy is complete. The checkpoint summary itself does not contain those journals or archive every external file or screenshot. Label missing/truncated evidence and do not copy secrets or full logs into state.

Keep a concise user-visible recovery pointer: sessionId/taskId, latest handoffId, returned taskUrl, primary machine and storage/note reference. A failed save is not a saved plan. On interruption, restore the session/checkpoint or target note, read newer events and original execution state before resuming. An empty caller workspace does not justify recreating the task or replaying it. See [context.md](../../computer-tasks/references/context.md) for storage limits and history.

A taskUrl opens the account-authenticated latest-task page; a handoffId names an immutable snapshot. Neither dispatches work, transfers host transcripts or carries temporary grants. Local links need existing authentication and network access. A missing/offline storage machine means unavailable plan content, not an empty plan or permission to infer success.
