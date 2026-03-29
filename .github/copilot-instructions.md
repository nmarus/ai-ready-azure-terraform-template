# GitHub Copilot Instructions

Read [`AGENTS.md`](../AGENTS.md) for full project context before suggesting changes. It contains architecture, file layout, naming conventions, how to add resources, and all enforced constraints.

## Critical Rules (enforced by tflint and CI — violations will fail)

- **Resources in `main.tf` only** — never define resource blocks in any other file
- **Name pattern**: `"<type>-${local.effective_workload}-${var.environment}-${var.region}"` — never hardcode names
- **All taggable resources must have** `tags = local.default_tags` (or a `merge()` of it)
- **Use `#` comments only** — `//` is rejected by the linter
- **Variables and outputs require** `description` and `type`
- **Before committing**: run `pre-commit run --all-files`
