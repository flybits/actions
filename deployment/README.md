# Deployment Action

GitHub Action for deploy backend services.

## Secrets

### `FLYBITS_GITHUB_TOKEN`

**flybitsbot** Github Token

## Example Usages

```yaml
name: Deployment

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Semver type of new version (major / minor / patch)'
        required: true
        type: choice
        options: 
        - patch
        - minor
        - major

jobs:
  deployment:
    name: Deployment
    runs-on: ubuntu-latest
    steps:
    - uses: flybits/actions/deployment@master
      with:
        version: ${{ github.event.inputs.version }}
        github_token: ${{ secrets.FLYBITS_GITHUB_TOKEN }}
        branch: ${{ github.ref_name }}
        who_trigger: ${{ github.actor }}
```
