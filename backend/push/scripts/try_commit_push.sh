#!/usr/bin/env bash

try_commit_push() {
  local tag="$1"
  local branch="$2"
  local repo_label="$3"
  local max_attempts="$4"

  if [ -z "$(git status --porcelain)" ]; then
    echo "No changes detected after kustomize edit. Image tag $tag is already set correctly in $repo_label. Nothing to commit."
    return 0
  fi

  git add .
  git commit -m "Auto-release $tag" || { echo "Commit failed. Exiting."; return 1; }

  # Every service pipeline writes to the same GitOps branch, so a rejected push is
  # normal under load rather than an error. Sleep first and rebase immediately before
  # the retry: rebasing and then sleeping leaves the refreshed base stale for the
  # whole sleep, so the next push is rejected again at any real concurrency.
  local pushed=false

  for i in $(seq 1 "$max_attempts"); do
    echo "Attempting to push (attempt $i/$max_attempts)..."
    if git push origin "$branch"; then
      echo "Upload Success"
      pushed=true
      break
    fi

    local sleep_time=$((RANDOM % 6 + 2))  # 2-7s, jittered so runners do not retry in lockstep
    echo "Push rejected, retrying in $sleep_time seconds..."
    sleep "$sleep_time"

    echo "Rebasing onto latest origin/$branch..."
    if ! git pull --rebase origin "$branch"; then
      echo "ERROR: rebase failed for $tag. $repo_label was NOT updated."
      git rebase --abort || true
      return 1
    fi
  done

  # Without this the loop falls through on exhaustion and the step exits 0,
  # reporting success while the Auto-release commit is discarded with the runner.
  if [ "$pushed" != true ]; then
    echo "ERROR: exhausted $max_attempts push attempts for $tag. $repo_label was NOT updated."
    return 1
  fi
}
