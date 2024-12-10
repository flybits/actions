# flybits/actions/frontend/nx/command

This action executes a specified command using Nx.

- Usage
  - [Inputs](#Inputs)
  - [Outputs](#Outputs)
- Examples
  - [How to run lint command](#Run-lint-command)
  - [How to run build command](#Run-build-command)
  - [How to post message in Slack if the build fails](#Post-a-message-in-Slack-if-the-build-fails)
  - [How to post message in Slack if the build fails](#Post-a-thread-reply-in-Slack-if-the-build-fails)
  - [Sample workflow for deploying to the development server](https://github.com/flybits/webapp-react-templated-experience/blob/develop/.github/workflows/deploy-development.yml)

## Usage

#### Inputs:

```yaml
- name: Run lint
  uses: flybits/frontend-github-actions/nx/command@main
  with:
    # A command to execute
    # Required
    command:

    # GitHub personal access token for accessing private NPM packages
    # Optional
    # The default value is ${{ github.token }}
    github-personal-access-token:

    # Message to send to Slack if the command fails
    # Optional
    # The default value is 'Nx command failed'
    slack-failure-message:

    # Notify a Slack channel if the command fails
    # Optional
    # The default value is true (will notify Slack)
    slack-notify-on-failure:

    # Notify a Slack channel if the command succeeds
    # Optional
    # The default value is false (will not notify Slack)
    slack-notify-on-success:

    # Message to send to Slack if the command succeeds
    # Optional
    # The default value is 'Nx command succeeded'
    slack-success-message:

    # Bot token for sending messages to Slack
    # Optional
    # The default value is false
    slack-bot-token:

    # Timestamp of the Slack thread message
    # Optional
    # The default value is false
    slack-thread-ts:

    # Human-readable name of the web application
    # Optional
    # The default value is ${{ github.event.repository.name }}
    web-app-name:
```

#### Outputs:

This job does not generate any outputs.

## Examples

#### Run lint

```yaml
- name: Run lint
  uses: flybits/actions/frontend/nx/command@main
  with:
    command: lint
```

#### Run build

```yaml
- name: Run build
  uses: flybits/actions/frontend/nx/command@main
  with:
    command: build:development
```

#### Post a message in Slack if the build fails

```yaml
- name: Run build
  uses: flybits/actions/frontend/nx/command@main
  with:
    command: build:development
    slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
    slack-failure-message: '😩 Building failed'
```

#### Post a thread reply in Slack if the build fails

```yaml
slack-notify-start:
  runs-on: ubuntu-latest
  outputs:
    ts: ${{ steps.slack-deploy-start.outputs.ts }}
  steps:
    - name: Notify Slack - deployment starting
      id: slack-deploy-start
      uses: flybits/actions/frontend/slack/deploy-start@main
      with:
        bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
        environment: Development
        web-app-name: ${{ vars.WEB_APP_NAME }}

build:
  needs: [slack-notify-start]
  runs-on: ubuntu-latest
  environment: development
  steps:
    - name: Run build
      uses: flybits/actions/frontend/nx/command@main
      with:
        command: build:development
        slack-bot-token: ${{ secrets.FE_SLACK_BOT_TOKEN }}
        slack-failure-message: '😩 Building failed'
        slack-thread-ts: ${{ needs.slack-notify-start.outputs.ts }}
```
