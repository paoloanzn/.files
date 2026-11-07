---
name: write-docs
description: Write, restructure, or review documentation for a software repository — the root README.md and a docs/ tree of Markdown pages (getting started, concepts, guides, reference, development, operations). Use when asked to document a project, write or overhaul docs, create a docs/ directory, improve a README, or audit existing documentation for accuracy and structure. Do not use for inline code comments, changelogs, or one-off prose unrelated to a repository.
---

# Writing repository documentation

Produce accurate, well-structured documentation that balances technical depth
with clarity, and prioritizes information density, readability and ease of
navigation. Work through the phases below in order. The final documentation
should be immediately useful, technically reliable, and proportionate to the
complexity of the project.

Reference example: the Tide docs at https://github.com/paoloanzn/tide
(`README.md` and `docs/`). [What the Tide docs show](#what-the-tide-docs-show)
distils its patterns. When unsure how a rule looks in practice, clone the repo
and read the matching page.

## 1. Assess

- Inspect the repository to understand its purpose, architecture,
  functionality and development workflows before writing anything.
- Locate and review existing documentation: `README.md`, `docs/`, examples and
  relevant inline documentation.
- Identify missing, outdated, duplicated or inaccurate information. Preserve
  and improve existing material where appropriate instead of rewriting it.
- Treat the implementation, tests and configuration files as the source of
  truth. Never document assumed or unimplemented behavior.

## 2. Categorize and set intent

- Determine whether the project is open source, publicly accessible or
  private, and identify its intended audience.
- **Private projects:** documentation primarily serves internal developers,
  maintainers and operators. Focus on architecture, development workflows,
  operational procedures and project-specific knowledge.
- **Public projects:** may need to serve a broader audience, including users,
  integrators and contributors.
- Identify the primary tasks readers need to accomplish and organize content
  around them. Different audiences may need different levels of technical
  detail.

## 3. Scope

Prioritize by practical value. Common areas:

- **Getting started:** installation, prerequisites and first-use instructions.
- **Concepts:** fundamental ideas, terminology and mental models.
- **Guides:** task-oriented instructions and workflows.
- **Reference:** precise descriptions of APIs, interfaces, configuration and
  behavior.
- **Development:** architecture, local setup, testing and contribution
  workflows.
- **Operations:** deployment, maintenance and troubleshooting.

Include only the sections relevant to the repository. Never create a page
solely to satisfy a predefined structure.

## 4. Structure

### Format

Unless told otherwise, use Markdown (`.md`) files in a hierarchical directory
structure. Use standard Markdown conventions, relative links for internal
navigation, and descriptive, lowercase, hyphenated filenames.

### File organization

- Documentation lives in `docs/` at the repository root.
- `docs/README.md` is the entry point: an overview of the documentation that
  acts as a contextual index, linking directly to the relevant pages and
  sections.
- The root `README.md` is a concise introduction to the project: its purpose,
  essential setup instructions, a minimal quick start, and a link to the full
  documentation.
- Use subdirectories to group related content. Avoid excessive nesting.

Example layout of `docs/`:

```text
docs/
├── README.md
├── getting-started/
│   ├── installation.md
│   └── quickstart.md
├── concepts/
│   └── architecture.md
├── guides/
│   └── workflows.md
├── reference/
│   ├── api.md
│   └── configuration.md
└── development/
    └── contributing.md
```

The real structure must reflect the project, not follow this example rigidly.
Tide, for instance, adds `language/` and `backends/` because those are its
natural divisions.

### Page organization

- Give each page a clear purpose and one coherent topic.
- Introduce the necessary context before details. Order information
  progressively: foundational concepts, then practical application, then
  advanced behavior.
- Keep related information together, avoid repetition, and link to an
  existing explanation instead of duplicating it.
- Prefer short, focused pages over large documents covering unrelated topics.

## 5. Write

### Language

- Keep a neutral, professional, technically precise tone.
- Use plain English wherever possible without sacrificing accuracy. Explain
  specialized terms when first introduced and use them consistently.
- Optimize for information density: every paragraph must communicate
  something useful. No filler, marketing language, redundant explanations or
  excessive verbosity.
- Guide the reader's reasoning. Establish the mental model before details
  that depend on it. Explain *why* something works when that understanding is
  needed to use it correctly.
- Balance conceptual explanation with concrete technical detail. Prefer
  specific statements over vague descriptions.
- Distinguish requirements, recommendations, defaults and optional behavior
  explicitly.

### Examples and code snippets

- Prefer minimal, realistic and reproducible examples.
- Introduce each example with enough context to understand its purpose.
- Add comments only where they explain non-obvious behavior.
- After the example, explain the important outcomes and implications.
- Keep examples consistent with the actual implementation and supported
  version. Run them where possible and copy real output.
- Use fenced code blocks with language identifiers, following
  [GitHub's guidance](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks).
- Avoid examples that are unnecessarily complex or introduce unrelated
  concepts.

### Visual representations

- Use diagrams, tables and similar representations only when they communicate
  better than prose.
- Avoid excessive ASCII diagrams and decorative representations. When a
  text-based diagram is needed, generate it procedurally (for example with a
  small script) so alignment is correct and consistent.

## 6. Verify and review

Review the documentation against the repository before declaring it done.

- **Correctness:** verify technical claims, commands, examples, file paths and
  configuration options against the implementation.
- **Completeness:** the intended audience can accomplish the documented tasks
  without unexplained assumptions.
- **Consistency:** terminology, formatting, naming and technical depth are
  uniform across pages.
- **Navigation:** internal links and anchors resolve, the documentation index
  is complete, and the hierarchy makes sense.
- **Relevance:** obsolete information, unnecessary duplication and speculative
  content are removed.

When delegating to parallel agents, give each a clear, non-overlapping scope
(for example one directory or one set of pages) and the same writing
conventions. Then review and integrate their output so the documentation
reads as one coherent whole.

## What the Tide docs show

Tide (`paoloanzn/tide`) is a language and CLI for describing local Solana
networks as code. Its docs apply the rules above as follows.

### Root `README.md`

In order: a one-paragraph statement of what the tool is and does; the
version; **Why Tide** (the problem in two sentences, then three bolded
benefits); **How a run works** (the core mental model as a numbered list of
phases); **Installation** (one command, then tables for supported platforms
and environment variables, then the manual and uninstall paths);
**Quick Start** (two examples of increasing scope, each with the command and
its real output, including what an error looks like); **Documentation** (four
links to the best entry points, not the full index); **License** (what the
license permits and requires, in plain words).

### `docs/README.md` as a contextual index

- Opens with the version and points first-time readers back to the root
  README.
- States the reading order: "The pages build on each other in the order
  listed below."
- Groups pages under headings (Getting started, Language reference,
  Reference, Guides, Backends, Contributing). Each group has a one-line note
  on when to read it, and a `| Page | Covers |` table where each row says what
  the page contains, not just its title.
- Ends with **Conventions used in these pages**: code block tags, that every
  example was checked with the real tool, that output is copied from real runs
  with paths shortened, and what is assumed (`tide` on `PATH`).

### Page patterns

- **Opening paragraph** states what the page covers and where adjacent topics
  live: "The block's place in a network and the statement-context rules are
  covered in [networks](networks.md)."
- **Concepts page** starts with the problem the tool solves, then the mental
  model, then one complete annotated example, then a table that splits the
  model into its parts (half, blocks, when it runs, what it can do).
- **Reference entries** follow one shape: a sentence on purpose and when to
  use it, a minimal example, a sentence explaining what the example does, then
  a field table:

  ```markdown
  | Field | Type | Default | Notes |
  |---|---|---|---|
  | `lamports` | `u64` | required | Use `rent_exempt(size)` for ... |
  | `owner` | `pubkey` | `system_program()` | |
  ```

  `required` and every default are explicit in the table.
- **Errors are shown, not described.** Diagnostics are pasted from real runs
  in `text` blocks, so readers recognise them when they hit them.
- **Timing of behavior is explicit**: what `tide check` catches versus what
  only `tide up` catches, and which exit code each failure produces.
- **Limitations** get their own sections, each with the triggering input and
  the exact error.
- **Tutorial** builds one file in numbered steps, each adding a single idea.
  It starts with **Before you start** (prerequisites) and says which output
  will differ on the reader's machine (pids, signatures, paths).
- **Contributor page** (`contributing/architecture.md`) grounds every claim in
  the build files: requirements tables quote `CMakeLists.txt` and
  `vcpkg.json`, presets and targets are listed as they are defined, and build
  commands are copy-pasteable.
- **Comments in examples** explain only non-obvious behavior, e.g.
  `// the same key on every machine, every run`.
- **Cross-links** point to specific sections by anchor
  (`../guides/lifecycle.md#--dry-run`) instead of repeating content.
