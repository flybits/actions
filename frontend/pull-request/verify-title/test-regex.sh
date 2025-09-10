#!/bin/bash

# --- ACTION LOGIC (Mirrored from action.yml) ---
# This function simulates the validation logic of the GitHub Action.
# It takes the PR title as the first argument, and optional inputs as the rest.
function validate_pr_title() {
    PR_TITLE="$1"
    INPUT_ADDITIONAL_SCOPES="$2"
    INPUT_ADDITIONAL_TYPES="$3"
    INPUT_JIRA_KEYS="$4"

    # --- DYNAMIC SETUP (from inputs) ---
    # SIMULATE THE DEFAULT: If jira-project-keys input is not provided, it defaults to 'PET'
    if [[ -z "$INPUT_JIRA_KEYS" ]]; then
        INPUT_JIRA_KEYS="PET"
    fi

    BASE_SCOPES="analytics|apns|audit-history|config|connector|content|content-manager|context-rule|control-tower|control-tower-organization|deps|deps-dev|developer-portal|email|experience|experience-studio|fcm|file-upload|flow-visualizer|github-actions|group|location|location-management|maker-cheker|merchant-portal|notifications|organization|project|push|release|rule|rule-builder|saml|schedule|security|security-alert|smart-targeting|sms|template-library|user-invite|zones-and-modules"
    BASE_TYPES="BREAKING CHANGE|build|chore|ci|docs|feat|fix|perf|refactor|release|revert|style|test"

    ADDITIONAL_SCOPES_TRIMMED=$(echo "$INPUT_ADDITIONAL_SCOPES" | xargs)
    ADDITIONAL_TYPES_TRIMMED=$(echo "$INPUT_ADDITIONAL_TYPES" | xargs)
    JIRA_KEYS_TRIMMED=$(echo "$INPUT_JIRA_KEYS" | xargs)

    COMBINED_SCOPES="$BASE_SCOPES"
    if [[ -n "$ADDITIONAL_SCOPES_TRIMMED" ]]; then
      COMBINED_SCOPES="${COMBINED_SCOPES}|${ADDITIONAL_SCOPES_TRIMMED}"
    fi

    COMBINED_TYPES="$BASE_TYPES"
    if [[ -n "$ADDITIONAL_TYPES_TRIMMED" ]]; then
      COMBINED_TYPES="${COMBINED_TYPES}|${ADDITIONAL_TYPES_TRIMMED}"
    fi

    # --- STEP-BY-STEP VALIDATION ---
    if ! [[ "$PR_TITLE" =~ ^([a-zA-Z ]+)(\(.*\))?(!?):(.+) ]]; then
      echo -e "\t❌ $PR_TITLE\n\t   Reason: INVALID FORMAT"
      return 1
    fi

    PR_TYPE="${BASH_REMATCH[1]}"
    PR_SCOPE_FULL="${BASH_REMATCH[2]}"
    PR_DESC_RAW="${BASH_REMATCH[4]}"
    PR_DESC_TRIMMED=$(echo "$PR_DESC_RAW" | xargs)

    if [[ -z "$PR_DESC_TRIMMED" ]]; then
      echo -e "\t❌ $PR_TITLE\n\t   Reason: MISSING DESCRIPTION"
      return 1
    fi

    if [[ "$PR_DESC_TRIMMED" == *\. ]]; then
      echo -e "\t❌ $PR_TITLE\n\t   Reason: DESCRIPTION ENDS WITH PERIOD"
      return 1
    fi

    if [[ "$PR_TYPE" != "BREAKING CHANGE" && "$PR_TYPE" != "$(echo "$PR_TYPE" | tr '[:upper:]' '[:lower:]')" ]]; then
      echo -e "\t❌ $PR_TITLE\n\t   Reason: INVALID TYPE CASING"
      return 1
    fi

    TYPE_REGEX="^(${COMBINED_TYPES})$"
    if ! [[ "$PR_TYPE" =~ $TYPE_REGEX ]]; then
      echo -e "\t❌ $PR_TITLE\n\t   Reason: INVALID TYPE ('$PR_TYPE')"
      return 1
    fi

    if [[ -n "$PR_SCOPE_FULL" ]]; then
      SCOPE_CONTENT=$(echo "$PR_SCOPE_FULL" | sed 's/(//' | sed 's/)//' | xargs)
      SCOPE_ONLY_REGEX="^(${COMBINED_SCOPES})$"
      JIRA_KEY_PART="${JIRA_KEYS_TRIMMED//|/|}"
      if [[ -z "$JIRA_KEY_PART" ]]; then JIRA_KEY_PART="[A-Z]+"; fi
      JIRA_REGEX="^(${COMBINED_SCOPES}) \| (${JIRA_KEY_PART})-[0-9]+$"

      if ! [[ "$SCOPE_CONTENT" =~ $SCOPE_ONLY_REGEX || "$SCOPE_CONTENT" =~ $JIRA_REGEX ]]; then
         echo -e "\t❌ $PR_TITLE\n\t   Reason: INVALID SCOPE OR JIRA FORMAT ('$SCOPE_CONTENT')"
         return 1
      fi
    fi

    echo -e "\t✅ $PR_TITLE"
    return 0
}

# --- TEST CASES ---
echo -e "\n🧪 Running Base Validation Tests (overriding default Jira key)..."
BASE_TEST_TITLES=(
    # Valid
    "feat(analytics): add new tracking event"
    "fix: resolve issue with login"
    "docs(github-actions): update README"
    "chore!: drop support for Node 12"
    "BREAKING CHANGE: new API version"
    "refactor(user-invite | PROJ-123): simplify invitation flow"
    "style(fcm): format push notification payload"
    # Invalid
    "Feat(analytics): capitalize type"
    "fix(wrong-scope): use an invalid scope"
    "docs: missing description "
    "test(project): end description with a period."
    "build(deps|PROJ-123): incorrect jira format"
    "ci(sms | WRONG-456): jira key not in allowed list"
)
for title in "${BASE_TEST_TITLES[@]}"; do
    validate_pr_title "$title" "" "" "PROJ|TEST"
done

echo -e "\n🧪 Running Tests with Default Jira Project Key ('PET')..."
validate_pr_title "feat(project | PET-123): this should pass with the default key"
validate_pr_title "feat(project | WRONG-123): this should fail with the default key"

echo -e "\n🧪 Running Tests with Additional Types & Scopes..."
validate_pr_title "hotfix(db): critical database patch" "db|api" "hotfix|wip" "PROJ"
validate_pr_title "wip: work in progress" "db|api" "hotfix|wip" "PROJ"
validate_pr_title "custom(api): should fail with invalid type" "db|api" "hotfix|wip" "PROJ"

echo -e "\n✨ Test script finished."
