# Host chat recovery

For ChatGPT resume 404 / tokenless_resume_unavailable or chat-read 429 errors, stop unchanged re-entry and refresh attempts. Follow server backoff; without guidance, wait before one further query. Do not use stop/regenerate to retry writes. Tool-side recovery does not prove host recovery; verify progress through new results or an actual subsequent request. The plugin cannot automatically wake or repair ChatGPT's conversation stream. Use durable runs for long execution and retain original request/run IDs in context_checkpoint at stage boundaries so later work can resume from completed state.

Verify the tool service, execution agent, and chat host independently. A tool result cannot prove the host received it or continued answering.
