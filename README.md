# Research Skills for Codex

这是一个面向 Codex 的研究技能集合仓库。当前包含文献检索、引用支撑分析与论文引用放置等技能，后续可以继续在 `skills/` 下添加其他研究技能，而不需要改变安装方式。

## 已包含技能

| Skill | 用途 |
| --- | --- |
| `find-literature` | 检查本地参考文献是否足够；在需要时查找经过 DOI 验证的论文；下载可用 PDF；维护 `doc/refs/index.md`。 |
| `analyze-paper-claim-support` | 分析引用论文是否支撑论文、综述或 proposal 中的具体表述，并在 `doc/reports/` 生成 Markdown 分析报告。 |
| `place-paper-citations` | 在 LaTeX 或普通文本中把论文引用放到其精确支撑的术语、对象、方法、系统、数据集、标准或论断旁边。 |

## 仓库结构

```text
skills/
  find-literature/
    SKILL.md
    agents/openai.yaml
    scripts/
  analyze-paper-claim-support/
    SKILL.md
    agents/openai.yaml
    scripts/
  place-paper-citations/
    SKILL.md
    agents/openai.yaml
scripts/
  install-skills.ps1
  install-skills.sh
```

`skills/` 下的每个目录都是一个独立 Codex skill。面向人的说明文档放在仓库根目录，单个 skill 目录里只保留 Codex 使用技能所需的文件。

## 安装步骤

先克隆仓库，然后在仓库根目录运行安装脚本。

PowerShell:

```powershell
.\scripts\install-skills.ps1
```

Bash, macOS, or Linux:

```bash
bash scripts/install-skills.sh
```

默认会安装全部技能，目标位置为：

- 如果设置了 `CODEX_HOME`，安装到 `$CODEX_HOME/skills`
- 如果没有设置 `CODEX_HOME`，安装到 `~/.codex/skills`

只安装某一个技能：

```powershell
.\scripts\install-skills.ps1 -Skill find-literature
.\scripts\install-skills.ps1 -Skill analyze-paper-claim-support
.\scripts\install-skills.ps1 -Skill place-paper-citations
```

```bash
bash scripts/install-skills.sh find-literature
bash scripts/install-skills.sh analyze-paper-claim-support
bash scripts/install-skills.sh place-paper-citations
```

安装到自定义 Codex home：

```powershell
.\scripts\install-skills.ps1 -CodexHome "D:\codex-home"
```

```bash
CODEX_HOME="$HOME/.codex" bash scripts/install-skills.sh
```

也可以手动安装：把 `skills/<skill-name>` 复制到 `<CODEX_HOME>/skills/<skill-name>`。其中 `<CODEX_HOME>` 是你的 Codex home 目录。

安装后，启动新的 Codex 会话，并显式请求使用技能，例如：

```text
Use $find-literature to find DOI-verified papers for this topic and update doc/refs.
Use $analyze-paper-claim-support to explain whether this citation supports the claim and write the report to doc/reports.
Use $place-paper-citations to add precise citations to this LaTeX paragraph.
```

## 添加更多研究技能

新增技能时，创建 `skills/<skill-name>/`，并包含：

- 必需的 `SKILL.md`
- 推荐的 `agents/openai.yaml`
- 可选的 `scripts/`、`references/`、`assets/`

技能名使用小写字母和连字符，并让 `SKILL.md` 里的 `name:` 与目录名保持一致。新增技能后，同步更新本 README 中的技能表。

## 许可证

MIT. 见 [LICENSE](LICENSE)。
