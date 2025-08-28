# flybits/actions/frontend/pull-request/notify

This GitHub Action automatically sends a formatted notification to a specified
Slack channel when a new pull request is opened.

The action extracts key information from the pull request such as the Jira
ticket ID from the title and urgency from labels and presents it in a clean,
easy-to-read format.

## Usage

### Inputs:

| Name               | Required | Default                               | Description                                    |
| ------------------ | -------- | ------------------------------------- | ---------------------------------------------- |
| `slack-bot-token`  | `true`   | `N/A`                                 | The bot token to use for posting to Slack.     |
| `slack-channel-id` | `true`   | `N/A`                                 | The Slack channel to post the message to.      |
| `web-app-name`     | `false`  | `${{ github.event.repository.name }}` | A human-readable name for the web application. |

### Outputs:

| Name                      | Description                              |
| ------------------------- | ---------------------------------------- |
| `slack-message-timestamp` | The timestamp of the sent Slack message. |

## Examples

To use this action, create a workflow file
(e.g., `.github/workflows/notify-pull-request.yml`) in your repository with
the following content:

```yaml
name: Notify pull request

on:
  pull_request:
    types: [opened]

jobs:
  notify-slack:
    if: github.event.pull_request.draft == false
    runs-on: ubuntu-latest
    name: Notify Slack

    steps:
      - name: Send message to Slack
        uses: flybits/actions/frontend/pull-request/notify@main
        with:
          slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
          slack-channel-id: ${{ vars.FE_SLACK_CHANNEL_ID }}
          web-app-name: ${{ vars.WEB_APP_NAME }}
```
