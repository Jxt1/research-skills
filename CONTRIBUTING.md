# Contributing

Thanks for improving this research skill collection.

## Add a Skill

1. Create `skills/<skill-name>/`.
2. Add a required `SKILL.md` with only `name` and `description` in YAML frontmatter.
3. Add `agents/openai.yaml` when the skill should appear cleanly in Codex skill lists.
4. Put deterministic helpers in `scripts/`, detailed optional guidance in `references/`, and reusable output assets in `assets/`.
5. Do not add README, install guides, or changelogs inside a skill folder.
6. Update the root `README.md` skill table and installation notes if needed.

Keep skill instructions concise. Prefer references and scripts for details that are only needed in specific situations.

## Validate Locally

Install the skills into a temporary Codex home before opening a pull request:

```powershell
.\scripts\install-skills.ps1 -CodexHome "$PWD\.tmp-codex"
```

```bash
CODEX_HOME="$PWD/.tmp-codex" bash scripts/install-skills.sh
```

Then start a fresh Codex session with that Codex home and try a realistic prompt for the changed skill.
