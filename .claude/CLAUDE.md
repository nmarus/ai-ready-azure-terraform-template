# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Read [`AGENTS.md`](../AGENTS.md) for full project context: architecture, naming conventions, how to add resources, constraints, and common commands. That file is the single source of truth shared across all AI coding agents.

## Claude Code Notes

- Use the Context7 MCP tool (`mcp__context7__resolve-library-id` / `mcp__context7__query-docs`) to fetch current Terraform provider and Azure documentation — do not rely solely on training data for provider API details.
- `.editorconfig` enforces 2-space indentation, LF line endings, and UTF-8 for all `.tf`, `.yml`, `.json`, and `.md` files.
