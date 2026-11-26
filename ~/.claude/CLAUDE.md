# claude.md

## Workflow

### AMF rule

- `AMF` is an abbreviation for "Ask me first". Everytime you find it in a message it literally means the following: "Use your question asking tool to ask me question in order to clarify any doubt or specify anything needed before you start". It can be used at the start of a conversation/task, but not necessarly.

### Scratchpad cleanup

- Everytime you find in a message the expression `CLEANJUNK` it means: "Clean up this session's scratchpad from any left-off artifacts that is occuping significant disk space". Before proceeding give a super short breakdown to the user about the session's scratchpad content and use your question asking tool to let the user approve your deletion plan.

## Git

### Commits Text

- Never co-sign commits.
- Always use the following commit template:
```text
<type>[optional scope]: <short summary in imperative mood>
<blank line>
[optional body: explain WHAT and WHY, not HOW]
<blank line>
[optional footer: reference issues, e.g., Resolves #123]
```

### PRs

- Never sign PRs with this footer: "🤖 Generated with [Claude Code](https://claude.com/claude-code)"
- The first PRs comment should use a series of simple and clear bullet point list to explain the changes and why they were made.
- Do not include any `Test` section with checkboxes.
- The second PR comment should be a merdmaid diagram or a small set of diagrams explaining the code changes in a way that they can be easily understood by the reviewer. Never install tools such as `mermaid-cli`, `playwright` or other chroumium depended tools to verify the diagrams, think twice to ensure they are correct but skip the checks.

## Code Style

### Co-location

- Keep related code and data together in the same file, near their point of use.
- Extract only when justified by actual reuse or clear ownership boundaries.
- When you want to create a new file always ask to the user first.
