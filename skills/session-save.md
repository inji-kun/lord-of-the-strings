---
name: session-save
description: Persist the current research state to config/session-state.md
---

<process>
1. Read `config/active-preset.txt` to determine if a preset is active. If the file is empty or missing, treat the active preset as "none".
2. If a preset path is specified, Read that file and apply its conventions.
3. Gather session metadata:
   - `schema_version`: always 1
   - `session_id`: read from the `CLAUDE_CODE_SESSION` environment variable; if unavailable, use "unknown"
   - `updated_at`: current time as an ISO 8601 timestamp (e.g. "2026-03-22T14:05:00Z")
   - `repo_head`: run `git rev-parse HEAD` in the repo root; if git is unavailable or the repo has no commits, use "no-git"
   - `active_preset`: the contents of `config/active-preset.txt` (trimmed); if empty or missing, use "none"
4. Fill the four markdown body sections from conversation context:
   - **Current Work**: the file currently being edited (with section/heading if known), and any computation in progress.
   - **Verified This Session**: identities checked, computations completed, or results confirmed during this session.
   - **Open Questions**: unresolved questions or uncertainties raised during the session.
   - **Next Steps**: concrete actions to take next.
   - If there is nothing to report for a section, write "None this session." as the sole bullet.
5. Write the assembled content to `config/session-state.md`, overwriting any existing file.
6. Confirm to the user: "Session state saved to config/session-state.md."
</process>

<output>
The file `config/session-state.md` with the following structure:

```yaml
---
schema_version: 1
session_id: <from CLAUDE_CODE_SESSION env var or "unknown">
updated_at: <ISO 8601 timestamp>
repo_head: <output of git rev-parse HEAD, or "no-git">
active_preset: <contents of config/active-preset.txt, or "none">
---
```

Followed by:

## Current Work
- **File:** <file path and section being edited>
- **Computation:** <description of computation in progress>

## Verified This Session
- <list of verified identities, computations, or results>

## Open Questions
- <list of unresolved questions>

## Next Steps
- <list of concrete next actions>
</output>
