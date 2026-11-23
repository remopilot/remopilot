# RemoPilot 1.4.0 MCP tools

This is the 1.4.0 hosted-cloud tool contract generated from the release source, not evidence that the service has been deployed. The connected server’s actual `tools/list` response remains authoritative. The Claude and Codex MCP URLs and authentication settings are declared in their respective plugin folders.

Version 1.4.0 uses a new tool contract. Updating this repository does not update the hosted service or a paired computer. Existing requests retain their original identifiers; never replay an uncertain operation.

The [machine-readable catalog](mcp-tools-1.4.0.json) includes each tool’s description, input schema, output schema, annotations, and published conditional input constraints. The selected computer’s catalog can impose additional capability, permission, version and schema limits.

| Tool | Function |
| --- | --- |
| `get_profile` | Return the profile represented by this connection’s validated credentials: stable opaque account ID, available name/email, and a Google or GitHub nickname. |
| `workspace_open` | Open or restore the account workspace picker. |
| `machine_list` | List this account’s non-revoked paired computers, online status, reported version, enabled capabilities and manual pairingUrl. |
| `machine_revoke` | Revoke one account-owned machine’s credentials. |
| `directory_list` | Browse authorized directories on an online machine. |
| `app_access` | Control an owned background application. |
| `app_record` | On macOS, record one explicitly selected window of an App entity owned by the original binding and session. |
| `desktop_view` | Read-only whole main-display screenshot for situational awareness. |
| `app_inspect` | Inspect native desktop capabilities, installed applications, owned windows, or retained application instances. |
| `app_permissions` | Request Accessibility or Screen Recording permission for native App control. |
| `read_files` | Read bounded line ranges from multiple regular text files under the configured local policy; maxBytes bounds combined returned content. |
| `write_file` | Atomically create or replace a regular text file, preserving existing permissions and refusing symlinks. |
| `batch_edit` | Apply exact, counted edits after preflight. |
| `project_journal` | Open or resume a project journal, find the newest unfinished task, or record a host-produced context summary. |
| `read_artifact` | Read a registered local artifact by artifactId, or create a private read-only snapshot from an allowed local path. |
| `manage_context` | Persist task working state, not chat history or authority. |
| `manage_call` | Read an original gateway call by callId without re-executing it, or list retained calls. |
| `task_state` | Read or update the client-local task status list for this original binding, authenticated session and caller. |
| `mcp_servers` | List MCP servers explicitly added by the owner on this machine. |
| `mcp_tools` | Connect to one owner-added MCP server on this binding and refresh its actual tools and input schemas for this session. |
| `mcp_call` | Call a tool on an owner-added MCP server using the same session and the serverFingerprint and inputSchemaSha256 from mcp_tools. |
| `run_command` | Run one non-interactive shell command as a durable job. |
| `manage_run` | Observe or manage existing durable runs on their original binding. |
| `cancel_run` | Request cancellation of a queued or running pipeline. |
| `device_run` | Plan or run a resumable iOS Simulator build/install/launch/screenshot/log workflow. |
| `gateway_inspect` | Inspect gateway profile, privacy-filtered diagnostics, usage statistics or recent call metadata. |
| `task_query` | Inspect the selected computer catalog, project instructions and Skill resources, original request receipts and events, project call history, task sessions, or a saved handoff. |
| `task_update` | Start or update a task session, bind its complete target set, record a request note, save project instruction settings, or save a handoff checkpoint. |
| `workspace_ui` | Workspace interface actions for temporary access consent and navigation shortcuts. |
| `target_select` | Select a computer or folder and automatically attach it to the task session. |

See the [connection Skill](../skills/cloud-connection/SKILL.md) for target selection and the [call contract](../skills/cloud-connection/references/calls.md) for schemas and recovery.
