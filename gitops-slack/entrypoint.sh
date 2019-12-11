#!/usr/bin/env bash

#
# GitHub Actions:
#   https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
#
# Slack Messaging:
#   https://api.slack.com/messaging
#   https://api.slack.com/messaging/managing
#   https://api.slack.com/messaging/composing
#   https://api.slack.com/messaging/interactivity
#   https://api.slack.com/reference/messaging/payload
#   https://api.slack.com/reference/messaging/blocks
#   https://api.slack.com/reference/messaging/block-elements
#   https://api.slack.com/reference/messaging/interactive-components
#   https://api.slack.com/reference/messaging/composition-objects
#

set -euo pipefail


git_tag=$(git tag --list --points-at HEAD)
commit_sha=$(git rev-parse --verify HEAD)
commit_message=$(git log --oneline -n1 | cut -c9- | sed 's/\"/\\\"/g')
github_user_name=$(curl -s "https://api.github.com/users/$GITHUB_ACTOR" | jq -r '.name')
github_avatar_url=$(curl -s "https://api.github.com/users/$GITHUB_ACTOR" | jq -r '.avatar_url')

# Feature branch / Pull request
if [[ -n "$CIRCLE_PULL_REQUEST" ]]; then
  pr_number=$(echo $CIRCLE_PULL_REQUEST | rev | cut -d '/' -f1 | rev)
  title="Pull Request: $commit_message"
  title_link="$CIRCLE_PULL_REQUEST"
# Master branch: Staging
elif [[ "$CIRCLE_BRANCH" == "master" && ! "$git_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  title="Commit Diff: $commit_message"
  title_link="https://github.com/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/commit/$CIRCLE_SHA1"
# Master branch & Release: Production
elif [[ "$CIRCLE_BRANCH" == "master" && "$git_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  title="Release Changelog: $git_tag"
  title_link="https://github.com/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/releases/tag/$git_tag"
# Default
else
  title="Commit Diff: $commit_message"
  title_link="https://github.com/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/commit/$CIRCLE_SHA1"
fi

curl \
  -H 'Content-type: application/json' \
  -X POST "<<parameters.webhook>>" \
  --data \
    "{
        \"text\": \"Deployed <<parameters.artifact>> version <<parameters.version>> to <<parameters.environment>>/<<parameters.region>>\",
        \"blocks\": [
            {
                \"type\": \"section\",
                \"text\": {
                    \"type\": \"mrkdwn\",
                    \"text\": \"Deployed \`<<parameters.artifact>>\` version \`<<parameters.version>>\` to \`<<parameters.environment>>/<<parameters.region>>\`\n*<$title_link|$title>*\"
                }
            },
            {
                \"type\": \"context\",
                \"elements\": [
                    {
                        \"type\": \"image\",
                        \"alt_text\": \"photo\",
                        \"image_url\": \"$github_avatar_url\"
                    },
                    {
                        \"type\": \"mrkdwn\",
                        \"text\": \"<https://github.com/$CIRCLE_USERNAME|$github_user_name>\"
                    }
                ]
            }
            <<# parameters.include_fields >>
            ,{
                \"type\": \"section\",
                \"fields\": [
                    {
                        \"type\": \"mrkdwn\",
                        \"text\": \"*Environment:*\n<<parameters.environment>>\"
                    },
                    {
                        \"type\": \"mrkdwn\",
                        \"text\": \"*Region:*\n<<parameters.region>>\"
                    },
                    {
                        \"type\": \"mrkdwn\",
                        \"text\": \"*Artifact:*\n<<parameters.artifact>>\"
                    },
                    {
                        \"type\": \"mrkdwn\",
                        \"text\": \"*Version:*\n<<parameters.version>>\"
                    },
                ]
            }
            <</ parameters.include_fields >>
            <<# parameters.include_actions >>
            ,{
                \"type\": \"actions\",
                \"elements\": [
                    {
                        \"type\": \"button\",
                        \"value\": \"verify\",
                        \"text\": {
                            \"type\": \"plain_text\",
                            \"text\": \"Verify\"
                        }
                    },
                    {
                        \"type\": \"button\",
                        \"value\": \"rollback\",
                        \"text\": {
                            \"type\": \"plain_text\",
                            \"text\": \"Rollback\"
                        }
                    }
                ]
            }
            <</ parameters.include_actions >>
        ]
    }"
