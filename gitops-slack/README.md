# Slack Action

GitHub action for sending messages and notifications for deployments, rollback, etc to Flybits [Slack](http://flybits.slack.com).

## Inputs

### `dev_webhook`

### `staging_webhook`

### `production_webhook`

### `canada_webhook`

### `europe_webhook`

### `include_fields`

### `include_actions`

## Example Usages

```yaml
name: Main
on: push
jobs:
  slack:
    name: Notify Slack
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: flybits/actions/slack@master
        with:
          webhook:
          environment:
          region:
          artifact:
          version:
```

```yaml
name: Main
on: push
jobs:
  slack:
    name: Notify Slack
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: flybits/actions/slack@master
        with:
          webhook:
          environment:
          region:
          artifact:
          version:
          include_fields:
          include_actions:
```

## Development

After making any change to this action, first make sure you pass the following checks:

```
npm run lint
npm run test
```

And, then run the following command to update the packaged distribution of this JavaScript action.

```
npm run package
```

## References

### GitHub Actions

  - https://github.com/actions/toolkit/tree/master/packages/core
  - https://github.com/actions/toolkit/tree/master/packages/github
  - https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-a-javascript-action
  - https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
  - https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows

### Slack APIs

  - https://api.slack.com/messaging
  - https://api.slack.com/messaging/managing
  - https://api.slack.com/messaging/composing
  - https://api.slack.com/messaging/interactivity
  - https://api.slack.com/reference/messaging/payload
  - https://api.slack.com/reference/messaging/blocks
  - https://api.slack.com/reference/messaging/block-elements
  - https://api.slack.com/reference/messaging/interactive-components
  - https://api.slack.com/reference/messaging/composition-objects
