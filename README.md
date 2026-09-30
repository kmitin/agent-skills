# agent-skills

General-purpose skills for AI coding agents, in the portable `SKILL.md` format:
a folder with a `SKILL.md` file, readable by Claude Code and other runtimes that
support agent skills.

Each skill ships with its **behaviour contract**: a Gherkin `.feature` file
written before the skill, which the skill implements and does not extend. Read
the scenarios to see exactly what a skill will and will not do.

## Skills

| skill | what it does |
|---|---|
| [`role-projection`](skills/role-projection/) | Maps your real experience onto a target role, beside an openly fictional mirror: a person who grew up in that city, shown as a CV, with a section on how they operate. Every real claim cites your profile file; everything unsupported is listed as a gap. Never invents facts, never creates accounts, never applies. |

## Install

Copy a skill folder into your skills directory, either personal or per project:

```bash
cp -R skills/role-projection ~/.claude/skills/
```

## License

MIT — see [LICENSE](LICENSE).
