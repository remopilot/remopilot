---
name: remote-development
description: Inspect, search and edit files, run development commands and verify changes in an explicitly selected RemoPilot project. Use for source work and authorized Git operations with the target's installed tools.
---

# Develop in the selected project

Use the [core calling contract](../remote-workspace/references/calls.md) once per task and target version. Reuse the explicit machine/project binding and session; bind a known authorized project directly, or use workspace_open when the target is unclear. Persist the actionable plan under the [planning contract](../remote-workspace/references/planning.md) before implementation.

1. Read applicable AGENTS.md/AGENTS.override.md, current relevant files and Git differences. Preserve unrelated changes; pause only files with unsafe conflicts.
2. Use read_files/get_file_info for known locations, repo_probe for structure, and search_repo/repo_context to locate code. Narrow searches by directory/symbol and follow pagination. Truncation is incomplete evidence. See [paths-and-budgets.md](../remote-workspace/references/paths-and-budgets.md) when path adaptation or response limits matter.
3. Use project-relative paths with pathMode="workspace", or remote absolute paths with pathMode="absolute". Omit repoPath/cwd to use the bound root. For run_command/run_pipeline subdirectories, put workDir on the outer workspace_call. Other project tools require their own exact project binding.
4. Edit with exact batch matches or write_file overwrite/content guards. On MATCH_COUNT, HASH_MISMATCH or HEAD_MOVED, reread current state and rebuild the smallest patch; do not weaken guards or replay a failed mutation unchanged.
5. Follow the user's and project's verification timing. Run necessary checks through the target's advertised tools, keeping implementation, build and runtime acceptance distinct. Use separate pipeline steps with stopOnFailure=true; shell exit zero alone can mask an earlier failure. Do not change build inputs while a build runs.

Independent work may run concurrently after checking shared resources. Declare git coordination for shell Git mutations; keep dependent stage/check/commit steps in a protected sequence. Inspect hooks and shared outputs before choosing other scopes. Inspection, commit, push, publication and installation each require their corresponding authorization.

Retain original execution and artifact references, inspect terminal state before depending on results, and report verification gaps plainly. Use [remote-mobile](../remote-mobile/SKILL.md) for iOS Simulator execution, [remote-app](../remote-app/SKILL.md) for installed app interaction, [remote-coordination](../remote-coordination/SKILL.md) for independent branches, or [recovery.md](../remote-workspace/references/recovery.md) for interrupted calls. Source-only work stays here.
