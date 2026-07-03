---
name: find-literature
description: Assess whether existing local references are sufficient for a user-provided topic, paragraph, claim, or research context; find recent DOI-verified academic papers first unless foundational or first-proposal papers are specifically needed; download available PDFs into doc/refs/; and maintain doc/refs/index.md. Use whenever Codex is asked to find, collect, cite, add, download, verify, evaluate, or organize papers/literature/references for a project, especially when the user mentions DOI, bibliography, related work, references, existing papers, enough papers, or doc/refs.
---

# Find Literature

Use this skill to collect literature for the current repository. The required output is a local `doc/refs/` folder containing downloaded PDFs when available and a maintained `doc/refs/index.md` index.

## Core Rules

- Browse the web when discovering new papers, verifying DOI metadata, checking PDF availability, or judging whether the current literature is up to date. Do not browse merely to add more papers if the existing local references are already sufficient for the user's request.
- Before searching, inspect the existing `doc/refs/index.md` if it exists. If the index is incomplete, malformed, inconsistent, or has broken local PDF links, warn the user and ask them to repair the index first. Do not continue literature search or add papers until the index is repaired, unless the user explicitly asks to repair it as part of the task.
- Before looking for new papers, judge whether the existing references are sufficient for the user's purpose. If they are sufficient, stop and tell the user that no new literature search is needed.
- Accept as input any topic, paragraph, claim, draft section, paper title, or research direction from the user.
- When searching for new papers, prefer the latest relevant papers by default, especially for systems, benchmarks, empirical claims, surveys, and state-of-the-art or related-work coverage. Use older papers only when they are foundational, define a classic theory or method, are the first paper to propose the concept, or are necessary for historical attribution.
- Only add a paper after DOI verification:
  - Resolve or query the DOI through DOI.org, Crossref, publisher pages, DBLP, ACM, IEEE, Springer, USENIX, VLDB, arXiv, OpenAlex, Semantic Scholar, or another credible scholarly source.
  - Confirm the DOI metadata title matches the candidate paper title.
  - Confirm at least one key content signal matches the user's need: abstract, keywords, venue, cited snippet, paper page, or full text.
- Do not add papers based only on search-result snippets.
- Prefer official or stable sources for PDFs: publisher open-access PDF, author institutional page, conference page, arXiv, HAL, Zenodo, or other legitimate open repositories.
- If the PDF cannot be downloaded legally or reliably, still add the paper to the index with `PDF: missing-pdf` and include the best DOI or landing-page URL so the user can download it manually.
- Do not overwrite existing PDFs or remove existing index entries unless the user explicitly asks.

## Repository Layout

Use paths relative to the current repository root:

```text
doc/refs/
  index.md
  <slugified-title>.pdf
```

If `doc/refs/index.md` does not exist, it is not considered broken. Create it with:

```markdown
# References

This index lists DOI-verified papers collected for this repository.

| Title | Year | Venue | DOI | PDF | Notes |
| --- | --- | --- | --- | --- | --- |
```

## Workflow

1. Run the preflight index check:
   - If `doc/refs/index.md` is missing, continue and create it when adding the first paper.
   - If the check reports problems, stop and tell the user the index should be repaired before using literature search. Include the reported problems and offer to repair them.
2. Read the user's input and identify the research intent, constraints, and keywords.
3. Assess existing-reference sufficiency:
   - Read `doc/refs/index.md` if present.
   - Inspect relevant local PDFs or notes when needed to understand coverage.
   - Decide whether the current references already cover the user's need.
   - If sufficient, stop and report the decision; do not search for new papers.
4. If existing references are insufficient or uncertain, explain the coverage gap briefly.
5. Search scholarly sources for candidate papers targeted to the gap, starting with recent publication years and current top venues or journals for the area.
6. For each candidate, locate and verify its DOI metadata.
7. Compare DOI title and key content with the candidate and the user's request.
8. Select relevant papers using the recency and classic-work policy below. Avoid weakly related papers even if they are easy to download.
9. Download PDFs into `doc/refs/` when a stable legal PDF is available.
10. Update `doc/refs/index.md` for every accepted paper, including papers whose PDF download failed.
11. Report the sufficiency decision, what was added, what could not be downloaded, and which DOI/source checks were used.

## Preflight Index Check

Use `scripts/check-refs-index.ps1` before any literature search when `doc/refs/index.md` already exists.

Treat the index as problematic if any of these are true:

- Missing required title or Markdown table header.
- Header columns are not exactly `Title`, `Year`, `Venue`, `DOI`, `PDF`, `Notes`.
- Any data row has the wrong number of table cells.
- Any data row has an empty title or DOI.
- Any DOI cell is not a DOI Markdown link to `https://doi.org/<doi>`.
- Two rows have the same normalized DOI or normalized title.
- A PDF cell links to a local file that does not exist under `doc/refs/`.
- A PDF cell is neither a local Markdown link nor `missing-pdf`.

If problems are found, do not silently fix them while searching. Ask the user to repair first, or ask permission to perform an index-repair task.

## Existing-Reference Sufficiency Check

Evaluate sufficiency before any new literature search. Use the user's stated purpose as the standard:

- For citing a simple factual/background claim, one or two highly relevant DOI-verified references may be enough.
- For related-work coverage, expect multiple complementary references across foundational work, closest competing systems/methods, and recent work.
- For a paper section that makes novelty or state-of-the-art claims, check whether the existing references include recent and directly comparable work; browse minimally if currentness is uncertain.
- For an implementation or system-comparison claim, ensure existing references cover both the conceptual method and comparable systems or benchmarks.

Treat existing references as insufficient when:

- `doc/refs/index.md` is missing or empty and the user needs citations.
- Existing entries are only loosely related to the user's paragraph or claim.
- Important subtopics from the user's request have no matching local reference.
- The set is stale for a claim that depends on recent work.
- Existing entries lack DOI verification notes, usable PDFs, or enough metadata to judge relevance.
- The user explicitly asks to expand, update, or find additional papers.

When references are sufficient, answer with:

- The decision that no new papers are needed.
- The local references that cover the request.
- Any caveat, such as "sufficient for background, not for a full related-work section."

## Recency and Classic-Work Policy

Default to recent literature when adding new papers:

- For active research areas, prefer papers from the last 3-5 years when they directly match the user's need.
- For related-work or state-of-the-art coverage, include recent directly comparable work before older background papers.
- For surveys, benchmarks, systems papers, and empirical comparisons, prefer the newest credible work because methods, baselines, datasets, and claims change quickly.
- Do not add an older paper merely because it appears high in search results, is highly cited, or is easier to download.

Use older papers when they have a clear role:

- Foundational theory or classic method that the user needs to cite.
- First paper that introduced a term, model, algorithm, workload, benchmark, or system family.
- Historical attribution needed to explain how an idea originated.
- Seminal baseline still used as the comparison point in recent work.

When both apply, add or recommend a balanced set: the original or seminal paper for attribution plus the latest directly relevant work for current context. Record that role in the `Notes` field, for example `DOI/title verified; seminal origin of graph query language theory` or `DOI/title verified; recent ICDE 2025 system comparison`.

## Index Entry Requirements

Each index row must include:

- `Title`: DOI-verified paper title.
- `Year`: publication year from DOI metadata or trusted source.
- `Venue`: conference, journal, archive, or publisher venue when known.
- `DOI`: DOI as a Markdown link to `https://doi.org/<doi>`.
- `PDF`: local PDF filename as a Markdown link, or `missing-pdf`.
- `Notes`: short relevance note plus verification status, for example `DOI/title verified; matches graph pattern matching workload`.

Before adding a row, check the index for an existing DOI or normalized title. If present, update only missing fields such as PDF filename or notes.

## Helper Script

Use `scripts/check-refs-index.ps1` for preflight validation and `scripts/update-refs-index.ps1` to initialize `doc/refs/` and add or update index rows after verification/download decisions are made.

Preflight example:

```powershell
& "$env:CODEX_HOME\skills\find-literature\scripts\check-refs-index.ps1" `
  -RepoRoot "D:\projects\GraphDatabase"
```

Example:

```powershell
& "$env:CODEX_HOME\skills\find-literature\scripts\update-refs-index.ps1" `
  -RepoRoot "D:\projects\GraphDatabase" `
  -Title "Example Paper Title" `
  -Year "2024" `
  -Venue "ICDE" `
  -Doi "10.1145/example" `
  -PdfFile "example-paper-title.pdf" `
  -Notes "DOI/title verified; relevant to subgraph query optimization."
```

Use `-PdfFile ""` or omit it when the PDF download failed; the script will write `missing-pdf`.

## Final Response

Keep the final response concise:

- Mention whether existing references were sufficient or why new search was needed.
- Mention the number of DOI-verified papers added or updated.
- List downloaded PDF filenames.
- List missing PDFs for manual download.
- Mention the index path.
