# GitHub Action: Yarn Command

Executes a specified command using Yarn, with optional Slack notifications for success or failure.

## Inputs

| Name                           | Description                                           | Required | Default                               |
| ------------------------------ | ----------------------------------------------------- | -------- | ------------------------------------- |
| `command`                      | A command to execute (e.g., `build`, `test`)          | Yes      |                                       |
| `github-personal-access-token` | GitHub token for accessing private NPM packages       | No       | `${{ github.token }}`                 |
| `slack-failure-message`        | Message to send to Slack if the command fails         | No       | `Yarn command failed`                 |
| `slack-notify-on-failure`      | Notify Slack if the command fails (`true`/`false`)    | No       | `false`                               |
| `slack-notify-on-success`      | Notify Slack if the command succeeds (`true`/`false`) | No       | `false`                               |
| `slack-success-message`        | Message to send to Slack if the command succeeds      | No       | `Yarn command succeeded`              |
| `slack-bot-token`              | Bot token for sending messages to Slack               | No       |                                       |
| `slack-thread-ts`              | Timestamp of the Slack thread message                 | No       |                                       |
| `web-app-name`                 | Human-readable name of the web application            | No       | `${{ github.event.repository.name }}` |

## Usage

```yaml
- name: Run Yarn Command with Slack Notifications
  uses: ./frontend/yarn/command
  with:
    command: build:production-demo
    slack-notify-on-failure: true
    slack-notify-on-success: true
    slack-bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
    slack-failure-message: 'Build failed! :x:'
    slack-success-message: 'Build succeeded! :white_check_mark:'
    web-app-name: 'My Web App'
```

## Example Workflow

```yaml
name: CI

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Install Node and NPM packages
        uses: flybits/actions/frontend/node-npm/install@main
        with:
          github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
          slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
          web-app-name: ${{ vars.WEB_APP_NAME }}

      - name: Build
        uses: flybits/actions/frontend/yarn/command@main
        with:
          command: 'build:production-demo'
          github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
          slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
          slack-notify-on-failure: true
          slack-failure-message: 'Build failed!'
          slack-notify-on-success: true
          slack-success-message: 'Build succeeded!'
          web-app-name: 'My Web App'
```

## Notes

- Slack notifications require a valid bot token (`slack-bot-token`).
- Slack notifications are sent only if the corresponding notify input is set to `true`.
- Customize the Slack messages using `slack-failure-message` and `slack-success-message`.
