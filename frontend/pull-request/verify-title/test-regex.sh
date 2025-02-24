#!/bin/bash

# Define an array of pull request titles
PR_TITLES=(
  "anker: sneaky sneaky change"
  "BREAKING CHANGE: extends key in config file is now used for extending other config files"
  "breaking change: uh oh"
  "BREAKING CHANGE(scope): major update"
  "feat: allow provided config object to extend other configs"
  "Feat: allow provided config object to extend other configs"
  "FeaT: allow provided config object to extend other configs"
  "FEAT: allow provided config object to extend other configs"
  "chore!: send an email to the customer when a product is shipped"
  "feat(): empty parentheses"
  "feat()!: empty parentheses with exclamation mark"
  "arman(analytics): arman was not consulted for this commit"
  "arman(bubu): arman was not consulted for this commit"
  "feat(merchant-portal | PET-123): add Polish language!"
  "feat(merchant-portal | ): add Polish language!"
  "feat(merchant-portal): add Polish language!"
  "docs(scope)!: send an email to the customer when a product is shipped"
)

function validate_pr_titles() {
  for PR_TITLE in "${PR_TITLES[@]}"; do
    if [[ "$PR_TITLE" =~ $REGEX ]]; then
      echo -e "\t✅ $PR_TITLE"
    else
      echo -e "\t❌ $PR_TITLE"
    fi
  done
}

echo -e "\nshould start with a lowercase word, except \"BREAKING\"\n"
REGEX='^(BREAKING CHANGE|[a-z]+).*$'
validate_pr_titles

echo -e "\nshould follow the Conventional Commit (https://www.conventionalcommits.org) format\n"
REGEX='^(BREAKING CHANGE|[a-z]+)(\(.+\))?!?: .+$'
validate_pr_titles

# Conventional Commit types: https://github.com/pvdlg/conventional-changelog-metahub
echo -e "\nshould use one of the following types: "
echo -e "BREAKING CHANGE, build, chore, ci, docs, feat, fix, perf, refactor, release, revert, style, test\n"
REGEX='^(BREAKING CHANGE|build|chore|ci|docs|feat|fix|perf|refactor|release|revert|style|test)'
validate_pr_titles


echo -e "\nshould use one of the following scopes: "
echo -e "analytics, audit-history, content, content-manager, context-rule, deps, deps-dev, experience, file-upload, flow-visualizer, location, location-management, maker-cheker, merchant-portal, notifications, push, release, rule, rule-builder, schedule, security, security-alert, smart-targeting, template-library, zones-and-modules\n"
REGEX='^([a-zA-Z ]+)(\((analytics|audit\-history|content|content\-manager|context\-rule|deps|deps\-dev|experience|file\-upload|flow\-visualizer|location|location\-management|maker\-cheker|merchant\-portal|notifications|push|release|rule|rule\-builder|schedule|security|security\-alert|smart\-targeting|template\-library|zones\-and\-modules).*\))?!?: .+$'
validate_pr_titles


echo -e "\nshould use the pipe character with spaces before and after (\" | \") to separate the scope and Jira ticket number in the pull request title\n"
REGEX='^([a-zA-Z ]+)(\([a-zA-Z1-9 |-]+\))?!?: .+' # Need to refine this regex to make it more stricter
validate_pr_titles

echo