# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zensical-based documentation for the 3D City Database (3DCityDB) v5. Live site: https://docs.brunowillenborg.de/

## Commands

```bash
# Install dependencies
pip install -U -r requirements.txt

# Serve locally with live reload
zensical serve

# Build static site
zensical build

# Build with clean cache
zensical build --clean

# Version management (mike)
mike deploy --update-aliases <version>        # Deploy a version
mike deploy --update-aliases <version> latest  # Deploy and set as latest
mike set-default latest                        # Set default version
mike serve                                     # Serve versioned docs locally
```

## Versioning and Deployment

- Uses squidfunk's forked `mike` for multi-version documentation
- `main` branch deploys as `edge` (development docs)
- `release-X.Y` branches deploy as versioned docs (e.g., `release-1.2` -> version `1.2`)
- The highest version among all release branches gets the `latest` alias
- CI workflow: `.github/workflows/ci.yml` (Python 3.13, auto-creates GitHub releases with `vX.Y` tags)
- Test repo: `bwibo/3dcitydb-mkdocs` (never push to `3dcitydb/3dcitydb-mkdocs`)

## Architecture

### Navigation

Navigation is defined explicitly in `mkdocs.yml` under the `nav:` key. To reorder pages or sections, edit that block directly.

### Content Structure

| Directory | Content |
|---|---|
| `docs/3dcitydb/` | Database schema docs (Feature, Geometry, Appearance, Metadata, Codelist modules) |
| `docs/citydb-tool/` | CLI tool docs (import, export, delete, Docker, CQL2 queries) |
| `docs/first-steps/` | Getting started, setup, migration guides |
| `docs/contributors/` | Contributor and organization pages |
| `docs/assets/` | Images, custom JS, custom CSS |
| `includes/` | Shared markdown includes (abbreviations auto-appended to all pages) |

### Theme and Extensions

Zensical (successor to MkDocs Material) with these customizations:

- **Abbreviations**: `includes/abbreviations.md` is auto-appended to every page via `pymdownx.snippets`. Add domain-specific abbreviations there (e.g., CityGML, CQL2, SRID).
- **KaTeX**: Math rendering via CDN + `docs/assets/javascripts/katex.js`. Use `$$...$$` or `$...$` syntax.
- **Tablesort**: All tables without a CSS class get sorting via `docs/assets/javascripts/tablesort.js`.
- **Mermaid**: Fenced code blocks with `mermaid` language for diagrams.
- **Page status**: Pages can set `status: wip` in frontmatter to show a "Work in progress" indicator.
- **Figure captions**: Use `/// figure-caption` or `/// caption` blocks (pymdownx.blocks.caption).

### Page Template

See `_template.md` for frontmatter structure (title, subtitle, description, status, tags) and markdown feature examples.

## Editing Guidelines

- Indent with 4 spaces (configured in `.vscode/settings.json`)
- TOC depth is limited to 3 levels (`toc_depth: 3`)
- Disabled markdownlint rules: MD024 (duplicate headings), MD033 (inline HTML), MD046 (code block style), MD007 (list indent)
