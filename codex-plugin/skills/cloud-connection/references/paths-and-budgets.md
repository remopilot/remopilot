# Paths, discovery and result budgets

## Project and machine paths

Project calls can use pathMode="workspace" with paths relative to the bound directory, or pathMode="absolute" with full paths on that remote machine. Both stay in the same binding. Missing pathMode uses the tool's native rules. Identical path strings on different machines are different files.

Omit repository repoPath or command cwd to use the bound root. Repository tools have repoPath, not interchangeable path/cwd aliases. run_command subdirectories use that operation’s own workDir field; the directory must exist inside the binding without symlink traversal. workDir does not narrow workspace coordination. For device_run and other repository tools, bind the exact project instead. TARGET_MISMATCH reports expectedPath/receivedPath; inspect them instead of silently switching targets.

Path adaptation changes only declared path fields, never shell text, content, globs or IDs. A shell cd changes subsequent relative paths. Inspect task_query(catalog).pathPolicy; never reuse one subproject's basis for another.

Machine bindings reject pathMode, workDir, cwd, repoPath and project paths. Commands start in the configured user work directory (platform defaults apply); this is distinct from the service data directory and is not a sandbox. Machine read_artifact uses artifactId from that binding. Files, repositories, device builds and manage_context need a project binding. Recover a project task on its original binding, not a new machine binding.

Keep task temporary files inside the selected project folder and use the same binding. AGENT_UPGRADE_REQUIRED is an unavailable capability, not permission to ignore parameters.

## Search and pagination

When commands are enabled, narrow `rg` by known directories, file types, symbols and error codes; exclude unrelated generated trees and sensitive paths such as `.env*`, keys and credentials. Avoid broad `--hidden`, `--no-ignore`, symlink following or unrestricted Git diffs. Use `--max-columns` with a preview and a bounded command-output budget. Inspect exit status, output limits and truncation; split the search into smaller paths or patterns rather than treating incomplete output as no matches. Use read_files(lineStart,lineCount) for known locations. A smaller match count does not shorten one oversized line. Shell output is not automatically protected by the retired search tools' sensitive-file exclusions.

read_artifact raw reads use maxBytes/byteOffset; structured queries use query/responseMaxBytes. Do not mix modes. JSON/NDJSON queries need query.format and JSON Pointer paths. On BUDGET_TOO_SMALL with recovery, use the returned raw-read arguments without retaining the old query and follow nextByteOffset. For oversized structured records, select fewer fields or a smaller object rather than repeating the same query.

Use each tool's actual byte/range limits; image, file and log budgets differ. manage_run logs take byteOffset/tail and return byteOffset/nextByteOffset; returned tailBytes is a count, not an input alias. Preserve gaps and truncation in the evidence summary.

Local relay can shorten duplicate text and device workflows; request its advertised fullResult or task_query(result, arguments={resultDetail:"full", ...originalSelector}) when needed. The hosted control plane does not accept resultDetail. Inspect the actual public schema and preserve images/resources alongside structuredContent. An artifact path is on the execution machine, not a caller-local file.
