---
name: place-paper-citations
description: Add, move, or audit academic paper citations in LaTeX or prose so each citation appears next to the exact claim, term, method, system, dataset, standard, theorem, or comparison it supports. Use when Codex is asked to add references, cite papers, place citations, fix citation placement, verify whether sentence-final citations are ambiguous, or edit paper paragraphs where different citations support different objects in the same sentence.
---

# Place Paper Citations

Use this skill to place citations where a reader can immediately see what each source supports.

## Core Rule

Attach each citation to the smallest clear textual unit it supports. Do not collect all citations at the end of a sentence when different citations support different objects, clauses, systems, methods, standards, or claims in that sentence.

## Workflow

1. Identify every cite-worthy unit in the target text:
   - named systems, languages, datasets, benchmarks, algorithms, standards, APIs, or papers
   - factual claims, definitions, comparisons, history, or empirical observations
   - phrases such as "widely used", "first introduced", "production systems", "state of the art", or "has been shown"

2. Map each citation key to exactly what it supports:
   - Read the surrounding bibliography entry, local report, paper note, or source text when available.
   - If the support is uncertain, do not silently place the citation; state the uncertainty or inspect the source.
   - If one source supports multiple adjacent units, cite it once at the nearest shared unit.

3. Place citations locally:
   - Put a citation immediately after the noun phrase or technical object it supports: `Cypher~\cite{...}`.
   - Put a citation after the clause it supports when the source backs an entire clause.
   - Put a citation before punctuation for normal LaTeX prose unless the local style already does otherwise.
   - Preserve nonbreaking spaces before citations in LaTeX: `... pattern queries~\cite{key}`.
   - Keep sentence-final citations only when all cited sources support the whole sentence or the same final claim.

4. Split or restructure overloaded sentences when citation placement would otherwise be awkward:
   - Prefer two clear sentences over a dense sentence with citations after every few words.
   - Use semicolons or parenthetical appositives only if they improve readability.
   - Avoid rewriting technical meaning merely to make citations easier.

5. Preserve existing citation commands and style:
   - Use the local command form, such as `\cite{}`, `\citep{}`, `\citet{}`, `\parencite{}`, or custom macros.
   - Keep existing key order when citations support the same unit unless the project has an ordering convention.
   - Do not invent BibTeX keys.

6. Validate the result:
   - For every citation, ask: "What exact words immediately before this citation does it support?"
   - For every citation cluster, ask: "Do all keys support the same unit?"
   - For every sentence, ask: "Could a reviewer mistake which paper supports which object?"
   - If yes, move citations closer or split the sentence.

## Placement Patterns

Use local placement when different references support different objects:

```tex
Cypher's \texttt{MATCH} clause~\cite{francis2018cypher,neo4jcypherpatterns}
and GSQL's path-pattern syntax~\cite{tigergraphgsqlpatterns}
expose graph pattern queries.
```

Use clause-level placement when a citation supports a whole clause:

```tex
OpenCypher-compatible systems reuse Cypher pattern syntax~\cite{amazonneptuneopencypher},
while GQL standardizes graph pattern matching semantics~\cite{deutsch2022gqlpattern}.
```

Use sentence-final placement only for shared support:

```tex
Subgraph matching is a central workload in graph query processing~\cite{key1,key2,key3}.
```

## Red Flags

Revise the citation placement when:

- a sentence names several systems but all citations appear at the end
- a citation cluster mixes standards, implementation manuals, and research papers
- a citation appears after a broad sentence but supports only one example
- a source for a method is placed after a result, or vice versa
- the same citation is repeated unnecessarily in adjacent text

## Output Expectations

When editing text, provide the revised text and briefly note any citations whose support remains uncertain. When modifying files, keep the diff focused on citation placement and nearby readability changes.
