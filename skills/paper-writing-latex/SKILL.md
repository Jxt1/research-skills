---
name: paper-writing-latex
description: Use when editing, reviewing, or adding academic paper prose in LaTeX files, especially sections such as introduction, motivation, framework, evaluation, related work, tables, captions, experimental setup, claims, placeholders, and TODO-driven manuscript changes. Apply when Codex modifies .tex paper text or LaTeX table/figure prose and should preserve publishable academic writing quality.
---

# Paper Writing LaTeX

Use this skill as a writing and editing checklist before changing academic LaTeX manuscript text.

## Workflow

1. Read the local paper context before editing: the target `.tex` file, nearby paragraphs, relevant tables/figures, and any TODO that motivated the change.
2. Separate manuscript prose from engineering notes. Keep local paths, script names, reproducibility commands, raw file locations, and implementation bookkeeping out of the paper body unless the paper is explicitly describing an artifact.
3. Write in publishable academic style: precise, concise, neutral, and claim-driven. Avoid conversational phrasing, internal task language, and temporary explanations.
4. Preserve LaTeX structure and references. Reuse existing labels, citations, macros, table style, section style, and terminology unless there is a clear reason to change them.
5. Leave explicit placeholders only when data is genuinely missing. Use `TBD` sparingly in generated tables or clearly marked draft text, and make sure a TODO records what remains.
6. After editing, scan the changed passage for local paths, unchecked claims, dangling references, awkward line-break artifacts, duplicate explanations, and inconsistent terminology.

## Paper Prose Rules

- Prefer concrete experiment terms over process terms. Write "Table reports dataset scale factors..." rather than "the statistics are generated under path...".
- Do not mention repository paths, scripts, or result directories in the manuscript body. Put those in experiment READMEs, TODO files, or artifact documentation.
- Do not overclaim. If results are not collected, state the measurement plan or leave a placeholder instead of implying completed experiments.
- Place citations next to the specific benchmark, method, dataset, or claim they support.
- Keep tables self-contained: captions should describe what is reported; surrounding prose should explain why the table matters, not how the file was produced.
- Use consistent terminology across the manuscript, such as "scale factor", "relationship type", "indexed property", "matching-based path", and "native execution".

## LaTeX Editing Rules

- Keep generated tables and `\input{...}` paths valid relative to `main.tex`.
- Preserve IEEE-style compactness: short paragraphs, compact tables, and informative captions.
- Avoid adding comments that explain obvious prose edits.
- Do not introduce local build artifacts or absolute filesystem paths.
- If a table is generated from a script, keep the script path and regeneration command in experiment documentation, not in the paper body.
