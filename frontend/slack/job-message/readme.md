# flybits/actions/frontend/slack/job-message

This action publishes a message to Slack when the job either succeeds or fails.

- Usage
  - [Inputs](#Inputs)
  - [Outputs](#Outputs)
- Examples
  - [How to post a message](#Post-a-message)
  - [How to post a thread reply](#Post-a-thread-reply)
  - [How to post a thread reply on failure](#Post-a-thread-reply-on-failure)
  - [How to post a thread reply on success](#Post-a-thread-reply-on-success)

## Usage

#### Inputs:

```yaml
- uses: flybits/actions/frontend/slack/job-message@main
  with:
    # The bot token to use for posting to Slack
    # Required
    bot-token:

    # The Slack channel to post the message to
    # Optional
    # The default value is 'C9YA9JUKG' (The channel name is 'slack-api-tests')
    channel-id:

    # The name of the environment
    # Optional
    # The default value is 'Not Specified'
    environment-name:

    # The message to post to Slack
    # Optional
    # The default value is '${{ github.event.repository.html_url }}/actions/runs/${{ github.run_id }}
    message:

    # The timestamp of the Slack message to update
    # Optional
    # The default value is empty
    update-ts:

    # The timestamp of the parent message to reply to
    # Optional
    # The default value is empty
    thread-ts:

    # The name of web application
    # Optional
    # The default value is ${{ github.event.repository.name }}
    web-app-name:
```

#### Outputs:

This job does not generate any outputs.

## Examples

#### Post a message

```yaml
- uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.slack-bot-token }}
    message: 'Hello world!'
```

#### Post a thread reply

```yaml
- uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.slack-bot-token }}
    message: 'Hello world!'
    thread-ts: ${{ needs.<job-id>.outputs.ts }}
```

#### Post a thread reply on failure

```yaml
- if: ${{ failure() }}
  name: Send failure message to Slack
  uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.slack-bot-token }}
    message: 'Job succeeded!'
    thread-ts: ${{ needs.<job-id>.outputs.ts }}
    web-app-name: 'Front-End Web App'
```

#### Post a thread reply on success

```yaml
- if: ${{ success() }}
  name: Send success message to Slack
  uses: flybits/actions/frontend/slack/job-message@main
  with:
    bot-token: ${{ secrets.slack-bot-token }}
    message: 'Job failed!'
    thread-ts: ${{ needs.<job-id>.outputs.ts }}
    web-app-name: 'Front-End Web App'
```
