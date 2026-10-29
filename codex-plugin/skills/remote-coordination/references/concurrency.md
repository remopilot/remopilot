# Parallel calls, background execution, and dependencies

## Choose an execution mode

| Capability | Usage | Evidence |
|---|---|---|
| Parallel tool calls | The host submits independent workspace_call requests on one binding, multiple bindings on one machine, or multiple machines | Retain separate receipts and original IDs; concurrent submission does not guarantee simultaneous starts |
| Parallel background tasks | Use separate run_command(mode="detached") calls or independent run_pipeline calls | Sequential host submission can still overlap background execution; observe each original runId |
| Caller-managed dependencies | Record upstream/downstream relationships and dispatch downstream only after required success and artifact verification | Relay complete, a fulfilled Promise, or a returned runId does not prove dependency readiness |

A RemoPilot machine agent executes tool requests, not independent model inference. The current MCP has no dedicated model-subagent creation, batch dispatch, or automatic dependency-graph scheduler. Compose existing calls for these workflows. run_pipeline steps are sequential with stopOnFailure=true by default; start separate runs for parallel branches. Background mode reduces foreground observation only and does not remove execution deadlines; configure them according to the current schema.

## Dispatch and join results

1. Map each action to an explicit target/binding and retain the task sessionId. Decomposition cannot expand authorization; implementation and test timing still follow the target project's instructions.
2. Read or reuse each target's valid exact schema and validate arguments individually. Inspect scripts, hooks, inputs, outputs, caches, ports, Git, and device instances. Parallelize only actions without ordering dependencies whose coordination declarations permit it.
3. Give each distinct action a stable requestKey. Set target idempotencyKey only when its schema supports it. Use host parallel submission if available; in JavaScript orchestration, Promise.allSettled can retain every result. Otherwise start independent background actions sequentially, saving each original ID and dispatching the next without waiting for execution to finish.
4. Retain machineId, bindingId, requestKey, requestId, runId/callId, status, and artifact locations per action. Leave unreturned IDs empty rather than reusing another action's ID. Even fulfilled Promises require checking tool errors and internal execution. Recover pending through current continuation/wait guidance while continuing independent work; never replay accepted actions.
5. Confirm each required upstream execution ended successfully and read/verify necessary artifacts. Preserve and query original records when execution is uncertain. Only then dispatch downstream with a new action key. Failures block only their dependencies; retain and continue independent work. Cancel only on explicit user request.

After INVALID_ARGUMENTS/CATALOG_STALE, pause undispatched siblings using the same invalid shape, refresh, and rebuild arguments. Accepted siblings retain original-ID recovery. WORKSPACE_BUSY means only the current conflicting action was not dispatched; follow blocker/next below without changing keys or scope to bypass it. One failure does not trigger batch cancellation, redispatch, or rollback.

## Example: run A and B, then C

For two independent project builds followed by artifact aggregation, first inspect shared caches, outputs, and ports. If independent, start run_command(mode="detached") on each binding and retain separate requestKey, requestId, and runId values. Submit concurrently when supported, or dispatch B immediately after receiving A's background receipt.

Query A and B through manage_run on their original bindings until actual terminal states are available. Dispatch aggregation C only after both succeed and required artifacts are read back and verified. If A fails, withhold C's dependency on A while B continues and keeps its results. Successful relay receipts with running internal executions still require observation.

Independent searches in one project may also run concurrently. If B reads a file newly written by A, finish and verify A first. Use the same per-action records/recovery across machines; never query runs through another binding or assume machines share files.

## Directory and resource coordination

Determine shared outputs and dependencies before selecting locks. Commands on project and machine bindings have no machine/workspace/repository scheduling lock by default; independent same-directory work no longer queues automatically. Reads are not guaranteed consistent snapshots during builds.

- Shared caches, ports, downloads, or build targets: `coordination: {scope: "resources", resources: ["cache:models", "port:8080"]}`. Different model weights writing one index must share the same cache key.
- Same/ancestor/descendant directory exclusion: `coordination: {scope: "workspace", resources: []}`. workDir does not narrow the bound-directory scope; overlaps are checked across bindingId values. Commands can also explicitly declare workspace in resources.
- Common Git repository: declare resources: ["git"]. The agent resolves the common Git directory, giving worktrees the same key. Ordinary builds do not automatically acquire it; Git checkpoint still protects its actual repository internally.
- System operations or effects with uncertain boundaries: `coordination: {scope: "machine", resources: []}`. This includes machine installation, update activation, LaunchAgent/launchctl and systemctl/service operations. Explicitly request this scope; machine bindings do not imply it. Known machine-wide commands under another scope return MACHINE_COORDINATION_REQUIRED before dispatch, producing no execution, run, or call.

arguments.resources and coordination.resources are merged, normalized, and deduplicated. workspace means the bound directory; git/repo:<path> means the common repository. These keys are no longer discarded. Do not mechanically add workspace/git to independent commands. Inspect scripts, hooks, caches, ports, and outputs and declare real conflicts; omitting locks cannot bypass existing protection. This is cooperative scheduling, not a Shell sandbox, and excludes external processes.

Atomic file writes, version guards, deduplication, database protection, and service lifecycle protection remain. device_run protects the actual device instance without automatically locking the repository/workspace; declare shared build outputs explicitly. Create an independent simulator on conflict. Apps use separate background instances and close self-created instances afterward. Read-only entity observation takes no desktop lock, and saving screenshots does not reserve the entire workspace; coordinate shared output files. Use app_access/app_run, never bare screen_* or web_focus to bypass entity/snapshot requirements.

Operations without scheduling locks still retain execution records so later machine/workspace locks cannot conflict with in-flight work. reservationHeld=false means no scheduling reservation, not execution completion. status/relayRequestStatus=complete means a readable relay receipt; if present, use subjectExecution.terminal/status to inspect the internal run/call and check output. Recover background runs, transport timeouts, and uncertain execution with original bindingId, requestId, and runId/callId. Known execution IDs on the wrong binding return EXECUTION_BINDING_MISMATCH and the original binding; do not guess another project. Existing locks survive waiting and upgrades; a cancellation request is not terminal evidence.

WORKSPACE_BUSY returns executed=false, dispatched=false, conflict.role=requested_reservation (requested scope/resources), the actual blocker with its scope/resources, and next before dispatch. It may include retryAfterMs/nextCheckAt. Follow next and establish the original request's exact terminal state before retrying the undispatched action with its original arguments/key. Do not change keys or declarations to bypass old locks. New-task defaults do not rewrite old scopes, resource keys, or results.

## Independent Git worktrees

For independent changes in one repository, first verify whether isolation is needed, current Git state, the starting point, and authorized directories. Reuse a suitable idle worktree. If a new one is needed, run Git worktree commands through enabled command tools, record the actual path/result, and bind it through the selector or workspace_bind. This uses existing Git/command capabilities, not an automatic worktree-management API.

Worktrees allow parallel file edits while commands follow the coordination rules above. They share Git metadata and may share caches/ports. Inspect commands and hooks, declaring common resources as needed or machine scope when effects cannot be bounded. Worktrees do not copy uncommitted changes, synchronize another machine, or automatically merge, push, or delete. Review and integrate within user authorization. Clean up only after confirming no running tasks or changes need preservation.

## Scope

Mutual exclusion covers these tools dispatched through the same relay. It does not cover other relays, manual local edits, or arbitrary background services. Recover only the current retained original-ID evidence; missing or incomplete evidence never permits replay or release of an unconfirmed execution.

`remopilot app-control --action restart|quit|enable-desktop|enable-commands` is a recognized machine mutation and requires `coordination:{scope:"machine",resources:[]}`. Its App/CLI lifecycle handshake independently refuses active or uncertain work; machine coordination does not authorize cancellation or prove drain. Enable-desktop/enable-commands additionally change machine capability policy only after the original PID exit is confirmed, so they must follow the user's explicit authorization and the same idle checks. Use a local lifecycle entry rather than stopping the agent through one of its own running commands.
