---
name: remote-coordination
description: Coordinate independent RemoPilot commands and background tasks on one or several explicitly selected computers. Use for parallel work, shared resources and caller-managed dependencies.
---

# Coordinate work across targets

Use the [core calling contract](../remote-workspace/references/calls.md) once per task and target version, and [concurrency.md](references/concurrency.md) for resource declarations and dispatch examples. Available tools come from each target's installed catalog.

Map every action to its machine and binding; project actions also retain the authorized path. Keep one task session and a stable primary record machine under the [planning contract](../remote-workspace/references/planning.md). The primary stores the plan and call index; original receipts stay on their executors. A multi-machine selection does not authorize every action everywhere.

- Inspect inputs, outputs, scripts/hooks, caches, ports, Git and devices before parallel dispatch. Commands have no default directory, repository or machine scheduling lock. Declare actual conflicts with workspace, resources or machine scope.
- Submit independent calls concurrently when the host supports it, or start separate detached commands. Steps inside run_pipeline remain sequential. A RemoPilot machine agent executes tools; it does not create model subagents or automatically schedule a dependency graph.
- Give every logical action a stable requestKey and preserve its original binding, requestId and runId/callId. On the hosted service, `session_manage(action="resume")` returns `liveProjection.continuations`: every request in the session still awaiting a readable receipt, across all machines, each with its exact `workspace_result` check. Use it at dependency boundaries instead of tracking or polling each machine separately. Review every result, including rejected calls. Dispatch downstream only after all required upstream executions succeed and their necessary artifacts are verified.
- A failure blocks its dependents. It does not authorize replay or cancellation of the batch. On invalid arguments, refresh the schema and rebuild only undispatched calls with that invalid shape. On WORKSPACE_BUSY, inspect the actual blocker and follow original-ID recovery without changing keys or scope.
- Use independent Git worktrees when needed for isolated changes, while coordinating shared Git metadata and build resources. Cross-machine transfer needs an explicit direction and overwrite policy; no automatic binary transfer or synchronization is implied.

Report results and limitations per target. Relay completion does not prove execution completion. Follow [recovery.md](../remote-workspace/references/recovery.md) for maintenance refusals, ownership mismatches or uncertain execution; preserve original IDs across service versions.
