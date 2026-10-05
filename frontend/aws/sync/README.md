# AWS S3 Sync

> Build → upload to Amazon S3 → refresh CloudFront

This GitHub Action deploys a built frontend application to an S3 bucket. After
the upload succeeds, it invalidates the CloudFront cache and waits for the
invalidation to finish.

## Quick start

Your build folder must already exist and contain files before this action runs.

```yaml
name: Deploy frontend

on:
  push:
    branches: [main]

permissions:
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v7

      - name: Build application
        run: |
          npm ci
          npm run build

      - name: Upload to S3
        uses: flybits/actions/frontend/aws/sync@main
        with:
          aws-cloudfront-distribution-id: ${{ vars.AWS_CLOUDFRONT_DISTRIBUTION_ID }}
          aws-iam-role: ${{ vars.AWS_IAM_ROLE }}
          aws-s3-bucket-name: ${{ vars.AWS_S3_BUCKET_NAME }}
          aws-s3-bucket-region: ca-central-1
          dist-folder-name: dist
```

## Required setup

- Configure GitHub OIDC access for the IAM role.
- Allow the role to list and upload objects in the target S3 bucket.
- Allow `cloudfront:CreateInvalidation` for the distribution.
- Add `s3:DeleteObject` only when using a delete option.
- Keep the role limited to the required repository, bucket, and distribution.

## Inputs

| Input | Required | Default | Purpose |
| --- | --- | --- | --- |
| `aws-cloudfront-distribution-id` | Yes | — | CloudFront distribution to refresh. |
| `aws-iam-role` | Yes | — | IAM role assumed through GitHub OIDC. |
| `aws-s3-bucket-name` | Yes | — | Destination S3 bucket. |
| `aws-s3-bucket-region` | Yes | — | AWS region containing the bucket. |
| `aws-s3-cache-control` | No | `public, max-age=0, must-revalidate` | Cache-Control metadata applied to uploaded files. |
| `aws-s3-sync-delete` | No | `false` | Deletes destination files missing from the build folder. |
| `aws-s3-sync-delete-all` | No | `false` | Force-uploads every file, then deletes stale destination files. |
| `aws-s3-sync-dryrun` | No | `false` | Previews S3 changes and skips CloudFront invalidation. |
| `dest-folder-name` | No | Bucket root | Optional destination folder inside the bucket. |
| `dist-folder-name` | No | Repository name | Local folder containing the built application. |
| `generate-build-json` | No | `false` | Adds deployment timestamps and the Git SHA to `build.json`. |
| `notify-slack-on-failure` | No | `false` | Sends a Slack notification when deployment fails. |
| `slack-bot-token` | No | — | Slack bot token; required when notifications are enabled. |
| `slack-ts` | No | — | Parent Slack message timestamp for a threaded reply. |
| `web-app-name` | No | Repository name | Application name shown in Slack. |

## Common options

### Preview a deployment

```yaml
with:
  aws-s3-sync-dryrun: "true"
```

No S3 objects are changed and CloudFront is not invalidated.

### Remove stale files

```yaml
with:
  aws-s3-sync-delete: "true"
```

Use this when S3 should exactly match the build folder. If
`dest-folder-name` is empty, stale files can be removed from the entire bucket.

### Force-upload every file

```yaml
with:
  aws-s3-sync-delete-all: "true"
```

This uploads every current file before removing stale files. It does **not**
empty the bucket first, so a failed upload cannot leave the site completely
empty.

### Enable Slack notifications

```yaml
with:
  notify-slack-on-failure: "true"
  slack-bot-token: ${{ secrets.SLACK_BOT_TOKEN }}
  web-app-name: Customer Portal
```

## Notes

- The build folder must exist, contain at least one file, and contain no
  symbolic links.
- Boolean inputs accept only `"true"` or `"false"`.
- Cache control applies to every uploaded file. Use `immutable` only when file
  names change whenever their contents change.
- `jq` is already available on GitHub-hosted runners. Install it first when
  enabling `generate-build-json` on a self-hosted or minimal runner.
