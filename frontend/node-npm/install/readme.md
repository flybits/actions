# flybits/actions/frontend/node-npm/install

This GitHub Action installs a specified Node.js version and project dependencies using either **Yarn** or **NPM**. It is optimized for speed by utilizing native global package caching. Dependencies are securely fetched and restored automatically based on your project's lockfile (`yarn.lock` or `package-lock.json`).

## Usage

### Inputs

| Name                           | Required | Default                               | Description                                                                                 |
| ------------------------------ | -------- | ------------------------------------- | ------------------------------------------------------------------------------------------- |
| `github-personal-access-token` | **true** | _N/A_                                 | A token used for accessing private NPM packages (published by Flybits Inc.).                |
| `node-version`                 | _false_  | `'lts/*'`                             | The version of Node to use (e.g., '22', 'lts/\*').                                          |
| `package-manager`              | _false_  | `'yarn'`                              | The package manager to use. Supported options: `'yarn'` or `'npm'`.                         |
| `git-ref`                      | _false_  | _N/A_                                 | The branch, tag, or SHA to check out. Defaults to the current workflow's default reference. |
| `notify-slack-on-failure`      | _false_  | `false`                               | Whether to notify a Slack channel if the job fails.                                         |
| `slack-bot-token`              | _false_  | _N/A_                                 | A bot token to publish a message on Slack.                                                  |
| `slack-ts`                     | _false_  | _N/A_                                 | The timestamp of the Slack message thread to reply to.                                      |
| `web-app-name`                 | _false_  | `${{ github.event.repository.name }}` | A human-readable name for your web application.                                             |

### Outputs

This action has no outputs.

## Examples

### Example 1: Minimal usage (Only required inputs)

If your project uses the repository's default branch, the latest LTS version of Node, and defaults to Yarn, you only need to supply the private access token.

```yaml
steps:
  - name: Install Node and Yarn packages
    uses: flybits/actions/frontend/node-npm/install@main
    with:
      github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
```

### Example 2: Minimal usage with NPM instead of Yarn

If your project relies on NPM instead of the default Yarn configuration, pass 'npm' to the package-manager input alongside your token.

```yaml
steps:
  - name: Install Node and NPM packages
    uses: flybits/actions/frontend/node-npm/install@main
    with:
      github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
      package-manager: "npm"
```

### Example 3: Default full usage (Yarn + Slack alert)

A complete configuration utilizing custom Node version and Slack update

```yaml
name: Build project

on:
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
      - name: Install Node and Yarn packages
        uses: flybits/actions/frontend/node-npm/install@main
        with:
          github-personal-access-token: ${{ secrets.FE_GITHUB_PAT }}
          node-version: "22"
          notify-slack-on-failure: true
          git-ref: ${{ github.head_ref }}
          slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
          slack-ts: ${{ needs.slack-notify-start.outputs.ts }}
```
