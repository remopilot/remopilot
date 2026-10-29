# Recover original execution

## Preserve identity

Keep the original session, binding, requestKey/requestId and actual runId/callId. If the first response was lost, workspace_result can look up the original requestKey on its original binding. This is observation, not redispatch. NOT_FOUND means no available record; it does not prove non-execution. A new binding or key cannot recover an old action.

Original authorization and path boundaries still apply. An offline generation, deleted directory, expired temporary grant or revoked permission can block recovery. Do not switch bindings or broaden access to bypass it. Existing recovery need not wait for loading fresh Skills, but it still uses the current supported tool schema.

## Read the right state

Relay complete means the original handler receipt is readable. Inspect subjectExecution when returned, then actual status, terminal/unfinished/closure evidence, exitCode and required effects. Cloud responses do not include the local relay's full execution or scheduling-occupancy projection. Missing fields are unknown; do not infer resource release from them. output is the historical receipt, while a newer executionObservation may describe later progress; observedAt=null or refreshPending does not establish live process state.

Use manage_run with the actual runId and manage_call with the callId. A query's own ended execution.version=1 receipt does not terminate its subject. A pending_call is an unfinished invocation with its own callId, not an invented run. If a handler returns a nested run, follow both as necessary. For resultAccess=current_run_snapshot, result describes the original run's current observation and originalResult retains history; verify status/unfinished/closure and exit codes. Large results can retain exact lifecycle fields in resultSummary while full content is an artifact.

Follow recovery.action and next: observe_original queries the supplied original target; review_result requires reviewing terminal outcome/partial effects; reconcile_original means evidence is insufficient. When next.tool is manage_run/manage_call, invoke it via workspace_call with the same subject ID and original binding, but a new observation requestKey. Follow retryAfterMs/nextCheckAt and do independent work between checks. Observation timeout, observer cancellation and foreground handoff never cancel the underlying execution. Stop polling once terminal failure is confirmed and review the failure.

Session resume may return blockingReview/nextAction for a detached task that ended unsuccessfully. Inspect the original evidence before continuing saved steps. The cloud may lack this local continuation projection; absence is not success, so inspect the original request directly. Host status dots, HTTP writes and assistantDelivery do not prove user-goal completion or continued chat execution. The plugin cannot wake a stopped host chat.

## Waiting policy

Use returned waiting and runtimeBudget rather than estimating deadlines from poll count. Synchronous observation warns at five minutes, escalates at eight and refuses further automatic waiting at ten. Detached work recommends a foreground handoff after thirty minutes; preserve the original ID and checkpoint material progress before ending observation. These limits never pause, cancel or restart the execution. Keep one observation chain per execution, follow the returned next check, and use an ETA only with measurable progress. Long work should continue independently within its actual execution limit.

## Refusals and correction

| Result | Required next step |
|---|---|
| REQUEST_NOT_DISPATCHED | This persisted request explicitly rejected dispatch. Follow details.next to the blocker; do not query a fabricated execution. |
| REQUEST_BINDING_MISMATCH / EXECUTION_BINDING_MISMATCH | Use the returned original binding/request pointer. The rejected control did not transfer ownership. |
| WORKSPACE_BUSY | Confirm this action was not dispatched, read blocker/next and establish the holder's original terminal state and release. Retry the undispatched action with its original arguments/key; never weaken scope or change targets to bypass it. |
| EXECUTION_ROUTE_UNCONFIRMED / EXECUTION_ROUTE_CONFLICT | Read next/recoveryChecks or the known original request. Preserve conflicting evidence; never synthesize owners, clear conflict records or route controls to current admission. |
| EXECUTION_GENERATION_OFFLINE / CLOUD_REQUEST_NOT_FOUND | The original route is unavailable. Retain its identity; do not launch a replacement. |
| DISPATCH_INTERRUPTED | The hosted dispatch ended before the request reached its machine; the original ID now holds an executed=false, dispatched=false receipt and its reservation is released. If the action is still needed, submit it with a new requestKey. |
| UPDATE_MAINTENANCE / GENERATION_RETIRING | A pre-dispatch refusal is not running work. Follow retry guidance with original IDs; maintenance may temporarily refuse observations too. |
| INVALID_ARGUMENTS / CATALOG_STALE | Refresh the exact schema and rebuild only undispatched calls sharing the invalid shape. Accepted siblings retain their IDs. |
| MATCH_COUNT / HASH_MISMATCH / HEAD_MOVED | Reread current state, build a corrected action and use a new action key after the failed mutation is confirmed ended. Never weaken guards. |
| STATE_FORMAT_UNSUPPORTED | Preserve retained evidence and report the incompatible state. No automatic conversion, deletion or replay is authorized. |

For DELIVERY_NOT_RECEIVED, only an explicit current not_started receipt with executed=false establishes that the original ID was sealed without execution. If the action is still needed and authorized, use a new requestKey while preserving its target idempotencyKey. A started or OUTCOME_UNKNOWN action remains uncertain and must not be rerun.

## Observations, input and cancellation

workspace_events records relay observations and user input; paginate by actual sequences. workspace_input is recorded_only for later planning, not stdin, interrupt or restart. Read new input before dependent dispatch.

Read-only manage_run status/log/wait can remain available after command-start permission is disabled. The tool also contains mutating extend, which requires its schema-declared idempotencyKey; ordinary status/log/wait does not require that mutation key. Extending and cancelling follow the user's requested scope and applicable permissions. A cancellation revision rejection proves only that cancellation did not dispatch; observe the original run. A returned empty active list is not global unlock proof. Check list complete/truncated/unreadable coverage before relying on it, and recover known executions individually.

Original work stays with its creating generation across upgrades. Version differences do not justify cancellation, migration or replay. retirementScheduled is not proof of retirement; CLOUD_RETIREMENT_BARRIER_REQUIRED, AGENT_RETIREMENT_HANDSHAKE_REQUIRED or GENERATION_RETIREMENT_UNCONFIRMED preserves the old service. Do not force-kill or clear records to turn missing evidence into completion.

Use [paths-and-budgets.md](paths-and-budgets.md) for log/artifact pagination, [context.md](../../remote-context/references/context.md) for journals, [platform-access.md](platform-access.md) for macOS permissions and [host-recovery.md](host-recovery.md) for host failures. Keep raw uncertainty in evidence and present “异常：执行状态待确认” when execution cannot be confirmed.
