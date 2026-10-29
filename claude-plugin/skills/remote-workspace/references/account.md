# Connected account, OAuth and usage

## Account identity

Use hosted get_profile({}) when asked which account the connection uses or when resolving a mismatch. It returns this token's opaque account ID and available profile fields; there is no account-selector argument. Do not infer it from a separate browser login. Google and GitHub accounts remain separate even when email matches.

Browser “Use another account” changes browser sign-in, not an existing plugin token. Reconnect or add the intended account through the host's available connection controls, then read get_profile again before selecting machines. Hosts differ in exposed controls. Switching accounts neither revokes machines nor stops their agents.

## Host connections and credentials

Each host has a separate OAuth namespace: ChatGPT `/chatgpt/mcp` (there is no unprefixed `/mcp` or `/oauth/*`), Claude `/claude/mcp`, Gemini `/gemini/mcp`, Muse `/muse/mcp`. Verify the provider's actual deployed entrypoint and connect from the intended host. Do not reuse another host's authorization code, access token or refresh token. Browser sign-in or saved source configuration is not proof that the connector is linked.

For manually configured clients, authenticated `/account/connections` generates a Client ID and one-time-visible Client secret. Use the exact callback URI supplied by that client and its supported client_secret_basic/client_secret_post method. A loopback client may use an OS-assigned port when the scheme, host, path and query still match the registered callback. Automatic registration clients can connect directly. Registration initially lasts 30 days; approved offline connections renew on successful use or refresh and expire after 30 inactive days. Access tokens last at most one hour. Expired/revoked connections require authorization again; an access-only connection needs new authorization to enable renewal. Creation does not approve scopes or pair a machine.

Never request secrets in chat or put them in URLs, logs, documentation or MCP arguments. Browser consent, S256 PKCE and account checks still apply. For Muse, use its native OAuth/Secure Vault flow and compare get_profile().id with the account ID in an authenticated setup prompt when provided. That ID is a comparison hint, not a credential or server-side selector. On mismatch, reconnect the intended account without revoking other connections. Its app-only workspace_access surface is not a command helper; use workspace_bind for an explicitly selected authorized root when no embedded picker is available.

## Usage and admission

Use current workspace_tools.billing for nominal invocation cost and default unlimited plan IDs. It is not the current account's entitlement or balance. New target-tool invocations, including observation calls, follow the returned policy; recovery of the original relay request is distinct from dispatching another target query. Never infer financial charges from the paid category alone.

CREDITS_REQUIRED rejects new execution before dispatch. Preserve available/required and use billingUrl/adminUrl/guidance from the response. Stop repeated new billable attempts; recover existing requests by original IDs. The authenticated account page supplies balance and refresh timing. Account changes, payments and administrator grants require their own authorization; do not change keys or targets to evade limits.

For selected project/account invocation counts, workspace_history(bindingId, source="agent", summary=true) returns the last 30 UTC days with freeCalls/paidCalls and scope/target/storage. These are returned-invocation counts, not an accounting ledger or verified operation outcomes. Unreturned calls, automatic recovery observations and cloud-only login/discovery/session operations are excluded; original-request redelivery reuses its record. Do not combine summary=true with detail identifiers or pagination. The original machine must be online and support historyUsage; an unavailable capability is not zero usage. Query each target independently. get_usage_stats is a separate gateway diagnostic with its own scope.

All plans, including Pro, meter each settled original target invocation once. Pro has no default monthly ceiling; administrator-set account limits still apply. `ACCOUNT_MONTHLY_LIMIT` is a pre-dispatch refusal: inspect the account allowance and contact an administrator. Never change keys to bypass it; recover already-admitted requests by original ID. Server dashboard statistics and machine-local history summaries have distinct scopes.
