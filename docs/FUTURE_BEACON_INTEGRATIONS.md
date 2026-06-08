# Future Beacon Integrations

The current Beacon is markdown-first and prompt-driven.

Future Beacon versions can connect to external systems and keep the repo loop in sync with the rest of the team’s work.

## Possible inputs

- GitHub issues, pull requests, reviews, labels, milestones, Projects
- PRDs in markdown, Google Docs, Notion, Linear docs, or Confluence
- task boards such as Linear, Jira, GitHub Projects, Trello, Asana
- CI status, test reports, deployment logs, error logs
- design sources such as Figma links or design-system docs
- customer feedback, analytics, support tickets, research notes
- Slack/Discord discussions and decision summaries

## Possible outputs

Beacon could update:

- `LOOP_RADAR.md`
- task briefs
- approval requests
- GitHub issues
- GitHub Projects fields
- Linear/Jira tasks
- PR comments
- Slack/Discord summaries
- release notes
- blocker lists

## Multi-Beacon teams

A larger team may run multiple Beacons:

- repo Beacon — whole-repo coordination
- product Beacon — PRD, roadmap, customer signals
- frontend Beacon — UI tasks and design alignment
- backend Beacon — APIs, contracts, data, infra
- team-member Beacon — personal task radar and status updates

All Beacons should write to shared coordination files or agreed external systems. They should not approve work unless your team explicitly gives them that authority.

## Safety rule

External integrations increase power and risk.

For early versions, prefer read-only access. Add write access slowly:

1. read GitHub/PRD/task list
2. draft updates locally
3. ask Project Lead approval
4. post/update external systems
5. log what changed
