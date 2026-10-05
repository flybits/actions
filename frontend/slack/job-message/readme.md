# Slack job message

> Post a Slack message for a workflow run

This GitHub Action posts a message to Slack. The message links to the current
workflow run. Pass `thread-ts` to reply in a thread, or `update-ts` to replace
an existing message.

## Quick start

```yaml
name: Notify Slack

on:
  push:
    branches: [main]

jobs:
  notify:
    runs-on: ubuntu-latest

    steps:
      - name: Post a Slack message
        uses: flybits/actions/frontend/slack/job-message@main
        with:
          bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
          message: Hello world!
```

## Inputs

| Input | Required | Default | Purpose |
| --- | --- | --- | --- |
| `bot-token` | Yes | — | Slack bot (`xoxb-`) or user (`xoxp-`) token with `chat:write`. |
| `channel-id` | No | `C9YA9JUKG` | Slack conversation ID. Public channels start with C, private channels with G, and direct messages with D. |
| `environment-name` | No | `Not Specified` | Name of the environment. |
| `message` | No | Workflow run URL | Link text for this workflow run. |
| `thread-ts` | No | — | Timestamp of the parent message to reply to. |
| `update-ts` | No | — | Timestamp of an existing message to replace. |
| `web-app-name` | No | Repository name | Name of the web application. |

## Common options

### Reply in a thread

```yaml
with:
  bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
  message: Hello world!
  thread-ts: ${{ needs.deploy.outputs.ts }}
```

### Reply when a job fails

```yaml
- if: ${{ failure() }}
  name: Send failure message to Slack
  uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
    message: Job failed!
    thread-ts: ${{ needs.deploy.outputs.ts }}
```

### Reply when a job succeeds

```yaml
- if: ${{ success() }}
  name: Send success message to Slack
  uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
    message: Job succeeded!
    thread-ts: ${{ needs.deploy.outputs.ts }}
```

### Update an existing message

```yaml
with:
  bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
  message: Job finished!
  update-ts: "1405894322.002768"
```

## Notes

- Pass `bot-token` from a GitHub secret. It must be a Slack bot (`xoxb-`) or user (`xoxp-`) token.
- `channel-id` must be a conversation ID, not a channel name. The default channel is `slack-api-tests`.
- `message` must be a single line of at most 4,000 characters and cannot contain `"`, `\`, `<`, `>`, or `|`.
- `thread-ts` and `update-ts` cannot be used together. Each timestamp looks like `1405894322.002768`.
- Setting `update-ts` replaces that message. Otherwise the action posts a new message.
