---
name: remote-tasks
description: Start, observe and recover RemoPilot background tasks, read their original logs and results, and record follow-up instructions. Use for existing request/run/call IDs; cancel only the task the user requests.
---

# Observe and recover execution

Use the [core calling contract](../remote-workspace/references/calls.md) once per task and target version. For interrupted or uncertain execution, read [recovery.md](../remote-workspace/references/recovery.md); original-ID recovery need not wait for skill reloading.

Retain sessionId, original bindingId, requestKey/requestId and actual runId/callId for every action. Start long work with the background mode advertised by its schema; observation and execution budgets are separate. Observe independent runs separately and continue unrelated authorized work.

1. Read workspace_result by the original binding and requestId, or the original requestKey if the first response was lost. A relay receipt marked complete only means its handler output is readable.
2. Inspect subjectExecution when present, then actual output, status, terminal/unfinished/closure evidence, exit code and required verification. A missing field is unknown, not false. The cloud does not supply the local relay's complete execution/occupancy projection; do not treat a cloud receipt as proof that the machine released resources.
3. Continue through manage_run with the original runId, or manage_call with the original callId. A finished observation query does not finish its subject. For current_run_snapshot, retain originalResult as history and inspect the current result; large results may require an artifact read.
4. Follow continuation/next and retry timing instead of busy polling. Each observation is a new query with its own request key; it keeps the queried execution ID unchanged. Missing records or unconfirmed state do not permit a replacement execution.
5. On later turns, resume the session and review blockingReview/nextAction. If a detached task ended unsuccessfully, inspect its original evidence before continuing dependent work. Once terminal error is confirmed, review it instead of polling indefinitely.

manage_run includes read-only queries and the mutating extend action; its overall tool annotation is therefore mutating. Ordinary status/log/wait remains observation. Extending the deadline and cancel_run affect execution and must follow the user's requested scope. A cancellation rejection proves only that cancellation was not dispatched; observe the original run to establish its state.

workspace_input records requirements for later planning. It does not send stdin, change a command or restart it. Read workspace_events incrementally before planning dependent actions. Read logs with byteOffset/tail and follow returned offsets; use search_log for focused evidence.

For WORKSPACE_BUSY, follow blocker/next and verify the holder's original terminal state and release before retrying the undispatched action. For binding or route errors, follow returned original targets; do not guess a project, clear locks or change keys to bypass them. Maintenance or generation changes preserve original execution ownership. Record uncertain state as “异常：执行状态待确认”, keeping raw uncertainty in evidence.

Completion requires actual execution and requested outcome evidence. Host animations, delivery acknowledgements, an idle list or a stored summary do not establish it. Preserve incomplete records and report the gap; deleting state cannot turn an uncertain task into a completed one.
