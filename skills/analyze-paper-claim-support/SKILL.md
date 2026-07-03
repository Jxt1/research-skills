---
name: analyze-paper-claim-support
description: Analyze how an original cited academic paper supports a claim in a manuscript, proposal, literature review, or paper draft. Use when the user asks whether a citation backs up a statement, how a cited paper supports a claim, whether a reference is appropriate, or asks to create a report under doc/reports/ based on a citation id, BibTeX key, DOI, PDF, or reference entry.
---

# Analyze Paper Claim Support

## Purpose

Use this skill to audit a citation-to-claim relationship. The output is a Markdown analysis report in `doc/reports/` explaining how the cited paper supports, partially supports, weakly supports, contradicts, or does not support the manuscript claim.

## Inputs To Recover

Identify these from the user request and repository before asking follow-up questions:

- Claim context: the sentence or paragraph containing the citation, plus nearby manuscript text if available.
- Citation identifier: BibTeX key, inline citation key, DOI, filename, reference id, or author-year label.
- Source paper: local PDF/text, DOI landing page, downloaded reference under `doc/refs/`, or bibliographic entry.
- Output title hint: a short phrase derived from the claim or cited paper title.

If any item is missing, search local project files first. Prefer `doc/refs/index.md`, bibliography files, manuscript `.tex` files, and PDFs under `doc/refs/`. If the paper is not local and external lookup is permitted or required by normal browsing rules, use DOI/publisher/arXiv/official sources first.

## Workflow

1. Locate the citation in the manuscript.
   - Capture the exact claim sentence and the surrounding paragraph.
   - Note the manuscript file path and line number when available.
   - Separate the core factual claim from rhetorical framing.

2. Locate and inspect the original paper.
   - Prefer full text over abstract-only evidence.
   - Read the abstract, introduction, method/system/model, experiments/evaluation, key results, discussion, and limitations.
   - Track page, section, table, figure, theorem, or experiment identifiers that matter.

3. Map evidence to the claim.
   - Identify which paper findings directly support the claim.
   - Identify whether support comes from empirical results, theoretical proof, system design, benchmark comparison, survey synthesis, or background framing.
   - Distinguish what the cited paper actually establishes from what the manuscript claim asserts.
   - Flag scope mismatches: workload, dataset, graph model, database engine, query language, metric, scale, baseline, hardware, year, or assumptions.

4. Judge support strength.
   - `Strong`: the cited paper directly demonstrates the manuscript claim with matching scope.
   - `Moderate`: the cited paper supports the claim, but with narrower scope or missing context.
   - `Weak`: the cited paper is related background but does not establish the claim.
   - `Contradictory`: the cited paper undermines or complicates the claim.
   - `Not found`: no clear support found in the inspected source.

5. Write the report.
   - Use `scripts/report_path.ps1` to generate a stable path from citation id and short title.
   - Create the directory if needed.
   - Keep quotes short; paraphrase evidence unless an exact phrase is necessary.
   - Do not change the manuscript unless the user explicitly asks for edits.

## Report Path

Run the helper from the repository root:

```powershell
$skillRoot = if ($env:CODEX_HOME) {
  Join-Path $env:CODEX_HOME "skills\analyze-paper-claim-support"
} else {
  Join-Path $HOME ".codex\skills\analyze-paper-claim-support"
}

& (Join-Path $skillRoot "scripts\report_path.ps1") `
  -CitationId "<citation-id>" `
  -ShortTitle "<short-title>" `
  -CreateDirectory
```

Filename format:

```text
doc/reports/<citation-id-slug>--<short-title-slug>.md
```

If there is no useful short title, omit `-ShortTitle`; the filename becomes `doc/reports/<citation-id-slug>.md`.

## Report Template

Use this Markdown structure:

```markdown
# Citation Support Analysis: <citation id> - <short title>

## Claim In Manuscript

- Location: `<path>:<line>`
- Citation: `<citation id>`
- Claim: <exact or lightly trimmed claim sentence>

## Cited Paper

- Reference: <title, authors, venue/year if known>
- Source inspected: <PDF/DOI/arXiv/local path>

## How The Paper Supports The Claim

<Explain the evidence chain from the cited paper to the manuscript claim. Mention specific sections, experiments, results, figures, tables, or arguments.>

## Support Strength

**Rating:** <Strong | Moderate | Weak | Contradictory | Not found>

<Justify the rating in 2-5 concise paragraphs.>

## Gaps And Caveats

- <Scope mismatch, missing evidence, ambiguous terminology, unsupported generalization, outdated result, etc.>

## Suggested Citation Use

<Say whether the citation is appropriate as-is, needs claim narrowing, needs another citation, or should be replaced. Include a suggested rewrite only if useful.>

## Evidence Notes

- <Paper section/page/table/figure>: <short paraphrase of relevant evidence>
```

## Quality Bar

- Ground every judgment in the cited paper, not in general field knowledge.
- Prefer precise language such as "supports for this benchmark setting" over broad language such as "proves".
- Treat surveys, position papers, and system papers differently: a survey can support field consensus, a position paper can support motivation, and a system paper can support observed behavior of that system.
- Mention uncertainty explicitly when only the abstract, citation metadata, or partial text was available.
- If the claim is compound, evaluate each subclaim separately.
