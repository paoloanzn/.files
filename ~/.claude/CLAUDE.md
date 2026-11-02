# claude.md

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

## Code Style

### Co-location

- Keep related code and data together in the same file, near their point of use.
- Extract only when justified by actual reuse or clear ownership boundaries.
- When you want to create a new file always ask to the user first.
