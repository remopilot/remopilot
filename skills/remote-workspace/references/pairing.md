# Installation and manual pairing

Use the provider's verified HTTPS installation entrypoint and the package actually available for the target. Source branches or a platform name do not establish an installable or accepted package. Installation, pairing and service activation have distinct outcomes; perform only the requested action. Commands execute with the machine's OS user permissions, and authorized directory scope is not a shell sandbox.

Only the user may approve pairing in the authenticated browser: personally enter the six-digit code shown on their own machine, preserving leading zeroes, review its identity/directories/capabilities and confirm. Never request the code in chat, fill/paste/type it through tools, approve it programmatically or use a link to prefill it. machine_pair returns the manual page link; it does not approve or open it automatically. If the user did not initiate the request, they must not enter the code.

Codes expire after ten minutes. The browser confirmation has a separate five-minute lifetime; if it expires, the user reopens the page and personally enters a still-valid code. On a headless machine they may use a browser on another device under the same account. MACHINE_LIMIT and rate-limit responses provide current limits or next steps; do not bypass them by generating repeated requests.

Setup normally registers the background service and connects after approval; an explicit no-service installation still needs manual start. Repeating setup preserves an existing identity rather than pairing again. Inspect actual startup/connection evidence, including login or boot-start constraints for that platform. Directory, command and desktop permissions are independent. Do not enable capabilities merely because a machine appears in the list.

Re-running setup before approval supersedes the previous pending code and returns a new one; a previously displayed code or approval page must not be reused. A cancelled or expired attempt can be restarted immediately with the same machine credential. If activation reports `PAIR_NOT_FOUND` or `PAIR_CLOSED`, use the newest code from the current terminal.

A revoked machine may be paired again with its original machine credential; approval restores the same machine ID and credential rather than creating a duplicate. The control plane refuses to transfer a revoked identity to a different account.

Machines use outbound connections. A reconnect or renewed expired code can preserve the unpaired machine ID; copying configuration copies identity and is not how to add a second computer. Approval establishes ownership, while readiness requires the separate live connection. machine_revoke removes access credentials, not already running OS jobs; revoked credentials can prevent later original-ID recovery. Confirm that consequence when revocation is the requested action.

For connected account mismatches, manual client credentials and ChatGPT/Claude/Gemini/Muse OAuth renewal, read [account.md](account.md). Login does not pair a machine, and loading a Skill does not grant command, directory or desktop access.
