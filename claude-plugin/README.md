# RemoPilot

RemoPilot connects Claude to computers you pair yourself. From one conversation you can work with an authorized project or machine, run its existing tools, follow long-running background work, recover the original request after a disconnect, and operate supported macOS applications in an owned background instance.

## What this plugin contains

- Six skills that describe how to select a computer, bind a project, run and verify work, coordinate several computers, and recover a task by its original request.
- `.mcp.json`, which declares one remote MCP server: `https://app.remopilot.com/claude/mcp`.
- An icon, this README, and the license files.

The bundle contains no hooks, no local executables, no background daemons, no bundled credentials, and no product source code. Skill bodies and their reference documents ship inside the plugin, so the plugin never fetches behavioral instructions from the server.

## Before you install

1. Create an account at <https://app.remopilot.com>.
2. Install the RemoPilot runtime on each computer you want to use, then pair it from the browser. Pairing requires you to type the six-digit code shown on that computer; the plugin never enters or approves it.
3. Connect the RemoPilot server in Claude and complete the OAuth sign-in when prompted.

Availability depends on the selected computer, its operating system, its installed tools, and the permissions you grant. This plugin supplies connection and workflow guidance; it does not install the runtime.

If you are upgrading from an older RemoPilot plugin, update the plugin, reconnect the server in Claude, and start a new conversation to load its current tools. Keep the original binding and request identifiers for any unfinished work and recover the existing request without replaying it. The plugin and the cloud service must support the same tool contract.

Selecting a project does not install that project's dependencies. Follow the project's own setup instructions on the selected computer. The computer owner can add supported local Skills and external MCP servers explicitly; reading their catalog does not start a server or install its dependencies.

## What it runs, sends, and receives

- Session, workspace, and machine tools are dispatched to the computer you selected. That computer runs the requested command or file operation with its own operating-system user permissions.
- Selected files, command output, and screenshots are relayed through the RemoPilot service into this conversation so Claude can read them.
- Persistent execution records, project files, and logs remain on the executing computer. The service retains account, routing, session, and billing metadata.
- The declared server URL is the only network endpoint in the plugin files. The plugin itself contacts no other host.
- Every new target invocation is metered under your plan. Recovering an existing request by its original identifiers remains available.

Native application control requires a usable desktop session and the permissions you grant. Terminal access does not prove that the background service can read the same project directory.

## Support and security

- Support: <https://app.remopilot.com/support>
- Documentation and release notes: <https://github.com/remopilot/remopilot>
- Report a security concern through the support page. Do not include credentials or private project content in a report.

## License

The plugin bundle, including its manifest, skills, README, and icon, is distributed under Apache-2.0. See `LICENSE` and `NOTICE`. The RemoPilot product source is not part of this bundle and is not licensed here.
