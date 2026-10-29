# Core remote calling contract

The installed MCP catalog owns schemas, permissions and execution. Skills compose those calls; they do not grant permissions or prove a source change is installed.

## Target, session and instructions

At first acquisition, identify the caller workspace and each confirmed execution machine, OS, project path or machine scope, and bindingId. Unselected targets remain pending. Caller-local notes are drafts; project edits, builds, tests, computation and authoritative artifacts run through the intended RemoPilot binding, even when caller and target share a physical computer. An unavailable target blocks its dependent work rather than authorizing a substitute environment.

Reuse one task session. If absent, call session_manage(start, requestKey), retaining sessionId/taskId. After creating or changing targets, call session_manage(action="bind", sessionId, bindingIds=[...], requestKey) with the complete intended binding set before workspace_call. Retain existing authorized targets unless their removal is intended; binding one new target does not append it to the session automatically. Include sessionId in every workspace_call, including observations and recovery. Changing the current selection never transfers an existing execution to another binding. Before implementation, save the actionable plan and verify its primary-machine storage under [planning.md](planning.md); restore it after interruption.

Skill bodies and references ship inside this plugin; read the relevant reference file directly. When the user asks you to follow the selected project’s own instructions, read workspace_context(read) or workspace_tools.context once and treat the returned content as user-authored project context. A selected custom skill of the same name on the target takes precedence. Resolve links relative to the current document. Read references only for the current operation. Reuse instructions while task, configuration, target version and fingerprint remain valid. No existing execution needs a skill reload.

## Discover and dispatch

For a known tool, use workspace_tools(detail="input", names=[tool]); use summary for capability discovery and full only when output schemas are needed. Category filters discovery, not permissions. includeStatus supplies coordination policy and diagnostics in the cloud; it is not a live list of machine occupants. Local relay may supply additional status fields. Use only actual returned fields.

Retain the target/catalog fingerprint. Validate every call's complete arguments against that tool's current inputSchema, including required fields, enums, ranges and additionalProperties. This does not require fetching the same valid schema before every call. bindingId, sessionId, requestKey, pathMode, workDir and coordination belong outside arguments. Put a target idempotencyKey inside arguments only if that schema declares it.

Pending discovery is recovered through its original workspace_result pointer. Its canonical query, runtime contract and schema fingerprints must match the original target and selection; CATALOG_FORMAT_UNSUPPORTED or CATALOG_QUERY_MISMATCH is not a usable catalog. After INVALID_ARGUMENTS or CATALOG_STALE, refresh the exact tool and rebuild undispatched siblings that used the invalid shape. Accepted siblings keep their original recovery IDs. Do not remove guards or expand to an unfiltered catalog to bypass a rejected selector.

Give each logical action a stable requestKey. A lost response is uncertain delivery: query the same binding and original key/ID, not a replacement action. A separately corrected action after proven pre-dispatch rejection may use a new key. Preserve its original rejection evidence.

## Coordination and evidence

Commands have no default machine, workspace or repository scheduling lock. Inspect actual shared inputs, outputs, scripts/hooks, caches, ports and devices. Declare workspace scope for overlapping directory dependencies, resources scope with consistent keys for bounded shared resources, git for Git mutations, and machine scope for installation, service registration and machine-wide effects. arguments.resources and coordination.resources merge. These scopes do not grant permission or sandbox shell commands. See [concurrency.md](../../remote-coordination/references/concurrency.md) for examples.

Every action retains its original machine/binding, requestKey/requestId, actual runId/callId and evidence references. Do not invent IDs or metadata arguments. Keep original receipts and artifacts on their executors; the primary plan contains a concise index, not automatically aggregated full journals. Update it at material milestones rather than after every observation.

status/relayRequestStatus=complete means the relay handler's receipt is readable. Inspect subjectExecution when present, then actual output, terminal/unfinished/closure state, exit code and required verification. A completed control query does not complete its subject. A missing occupancy field is unknown; reservationHeld=false, when actually returned, is not execution-completion proof. Report uncertain execution as “异常：执行状态待确认”. Follow original-ID [recovery.md](recovery.md); do not replay writes to obtain cleaner evidence.

## Read only the relevant detail

- Initial plan, target roles or changing primary storage: [planning.md](planning.md).
- Paths, workDir, scratch, pagination or oversized results: [paths-and-budgets.md](paths-and-budgets.md).
- Pending, busy, disconnect, maintenance or binding errors: [recovery.md](recovery.md).
- Full journals and handoffs: [context.md](../../remote-context/references/context.md).
- Connected account, credentials or usage: [account.md](account.md).
- App identity and images: [remote-app](../../remote-app/SKILL.md).

Permissions, capabilities and schemas are target-specific. Partial success on one machine is not success everywhere. Updating source, a plugin, a service and an installed agent are separate operations.
