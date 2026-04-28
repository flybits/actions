# Update GitHub Secret

This GitHub Action updates a GitHub environment or repository secret using the GitHub CLI.

It is designed to handle secret updates securely by passing the value via `stdin` using a heredoc, preventing the secret from being exposed in process listings. It also provides a clear job summary in the GitHub Actions UI upon completion.

## Usage

### Inputs:

| Name           | Required | Default | Description                                                              |
| -------------- | -------- | ------- | ------------------------------------------------------------------------ |
| `github_token` | `true`   | `N/A`   | A token with `secrets:write` permissions (typically a PAT).              |
| `secret_name`  | `true`   | `N/A`   | The name of the secret to update.                                        |
| `secret_value` | `true`   | `N/A`   | The value to be assigned to the secret.                                  |
| `environment`  | `false`  | `''`    | The GitHub environment name. If omitted, a repository secret is updated. |

### Outputs:

This action has no outputs.

## Examples

To use this action, add the following step to your workflow job. Adjust the `uses:` path to point to the location of this action in your repository.

### Updating a repository secret

```yaml
- name: Rotate API token
  uses: flybits/actions/frontend/general/update-github-secret
  with:
    github_token: ${{ secrets.MY_PAT }}
    secret_name: "API_TOKEN"
    secret_value: ${{ steps.generate.outputs.new_key }}
```

### Updating an environment secret

```yaml
- name: Update API token
  uses: flybits/actions/frontend/general/update-github-secret
  with:
    environment: "production"
    github_token: ${{ secrets.MY_PAT }}
    secret_name: "API_KEY"
    secret_value: "super-secret-password-123"
```
