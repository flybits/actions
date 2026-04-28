# Update Flybits Project Token

This GitHub Action refreshes a Flybits project JWT and automatically updates the corresponding GitHub secret.

It handles communication with the Flybits SSO API, manages token rotation with built-in retry logic (up to 3 attempts), and ensures the new token is masked in logs. For security, this specific action is restricted to updating the `FLYBITS_PROJECT_TOKEN` secret only.

## Usage

### Inputs:

| Name                          | Required | Default | Description                                                                   |
| ----------------------------- | -------- | ------- | ----------------------------------------------------------------------------- |
| `flybits_project_environment` | `true`   | `N/A`   | The Flybits environment to target (`development` or `staging`).               |
| `flybits_project_jwt`         | `true`   | `N/A`   | The current Flybits project JWT to be refreshed.                              |
| `github_token`                | `true`   | `N/A`   | A token with `secrets:write` permissions (typically a PAT).                   |
| `secret_name`                 | `true`   | `N/A`   | The name of the GitHub secret to update. **Must be `FLYBITS_PROJECT_TOKEN`**. |
| `github_environment`          | `false`  | `''`    | The GitHub environment name. If omitted, a repository secret is updated.      |

### Outputs:

This action has no outputs.

## Examples

To use this action, add the following step to your workflow job.

### Refreshing project token for the staging

```yaml
- name: Refresh Flybits project token
  uses: flybits/frontend-github-actions/general/refresh-flybits-project-token@main
  with:
    flybits_project_environment: ${{ vars.FLYBITS_PROJECT_ENVIRONMENT }}
    flybits_project_jwt: ${{ secrets.FLYBITS_PROJECT_TOKEN }}
    github_environment: "staging"
    github_token: ${{ secrets.YOUR_GITHUB_PAT }}
    secret_name: "FLYBITS_PROJECT_TOKEN"
```
