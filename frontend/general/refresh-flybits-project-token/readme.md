# Update Flybits Project Token

This GitHub Action refreshes a Flybits project JWT and automatically updates the corresponding GitHub secret in either a repository or environment scope.

It handles the communication with Flybits SSO APIs, manages token rotation with built-in retry logic (up to 3 attempts), and ensures the new token is masked in logs before being saved back to GitHub.

## Usage

### Inputs:

| Name                          | Required | Default | Description                                                              |
| ----------------------------- | -------- | ------- | ------------------------------------------------------------------------ |
| `flybits_project_environment` | `true`   | `N/A`   | The Flybits environment to target (`development` or `staging`).          |
| `flybits_project_jwt`         | `true`   | `N/A`   | The current Flybits project JWT to be refreshed.                         |
| `github_token`                | `true`   | `N/A`   | A token with `secrets:write` permissions (typically a PAT).              |
| `secret_name`                 | `true`   | `N/A`   | The name of the GitHub secret to be updated with the new token.          |
| `github_environment`          | `false`  | `''`    | The GitHub environment name. If omitted, a repository secret is updated. |

### Outputs:

This action has no outputs.

## Examples

To use this action, add the following step to your workflow job. Adjust the `uses:` path to point to the location of this action in your repository.

### Refreshing a Development Token

```yaml
- name: Refresh Project Token
  uses: ./.github/actions/update-flybits-project-token
  with:
    flybits_project_environment: "development"
    flybits_project_jwt: ${{ secrets.FLYBITS_PROJECT_JWT }}
    github_token: ${{ secrets.MY_PAT }}
    secret_name: "FLYBITS_PROJECT_JWT"
```
