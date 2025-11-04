# flybits/actions/frontend/node-and-npm/install


This GitHub Action installs a specified Node.js version and the project's
NPM packages (using Yarn).

It's optimized for speed by caching the `node_modules` directory based on the
`yarn.lock` file. Dependencies are only installed from scratch if the cache is
missed.

## Usage

### Inputs:

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `github-personal-access-token` | `true` | `N/A` | A token used for accessing private NPM packages (published by Flybits Inc.). |
| `node-version` | `false` | `'lts/*'` | The version of Node to use (e.g., '18', 'lts/\*'). |
| `ref` | `false` | `N/A` | The branch, tag, or SHA to check out. Defaults to the current workflow's ref. |
| `notify-slack-on-failure` | `false` | `false` | Whether to notify a Slack channel if the job fails. |
| `slack-bot-token` | `false` | `N/A` | A bot token to publish a message on Slack. |
| `slack-ts` | `false` | `N/A` | The timestamp of the Slack message to reply to. |
| `web-app-name` | `false` | `${{ github.event.repository.name }}` | A human-readable name for your web application. |

### Outputs:

This action has no outputs.

## Examples

To use this action, add the following step to your workflow job. Adjust the
`uses:` path to point to the location of this action in your repository.

```yaml
name: Build Project

on:
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
    - name: Install Node and NPM packages
      uses: flybits/actions/frontend/node-npm/install@main
      with:
        github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
        node-version: '18'
        notify-slack-on-failure: true
        ref: ${{ github.head_ref }}
        slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
        slack-ts: ${{ needs.slack-notify-start.outputs.ts }}
