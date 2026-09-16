---
name: create-pull-request
description: >
  Create a GitHub pull request using conventional commits validation.
  Use when the user says 'create PR', 'open PR', 'make a pull request', or 'create pull request'.
---

# Create Pull Request Skill

This skill is the canonical pull request flow.

You MUST follow these steps in order to create a pull request.

## Step 1: Validate Branch

- Run:

  ```bash
  current_branch="$(git branch --show-current)"
  default_branch="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
  ```

- If `default_branch` is empty, run:

  ```bash
  default_branch="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
  ```

- If `current_branch` is empty, stop and tell the user the current Git branch could not be determined.
- If `default_branch` is empty, ask the user which base branch to use.
- If `current_branch` equals `default_branch`, stop and tell the user they must switch to another branch before creating a pull request.

## Step 2: Determine Base Branch

- If the user specified a base branch, use it.
- Otherwise, use the detected `default_branch`.
- If no default branch can be detected, ask the user which base branch to use.

## Step 3: Gather Changes

Replace `<base-branch>` with the selected base branch.

- Run `git log --oneline <base-branch>..HEAD` to list all commits.
- Run `git diff <base-branch>...HEAD --stat` to see changed files.
- Run `git diff <base-branch>...HEAD` to read the full diff.

## Step 4: Validate Conventional Commits

Every commit message SHOULD follow:

```text
type(scope): subject
```

Allowed types by default:

- `fix`
- `feat`
- `docs`
- `style`
- `refactor`
- `test`
- `build`
- `chore`
- `revert`
- `hotfix`

Scopes are project-specific. If the repository documents allowed scopes, use those. Otherwise, accept any lowercase scope that is meaningful for the project.

If any commit does not follow this format, warn the user before proceeding.

## Step 5: Generate PR Content

Use the commits and diff to fill in this template.

**Title:** Use the conventional commit format, for example `fix(api): resolve auth timeout`. If there are multiple commits, summarize them into a single conventional commit title.

**Body:**

```markdown
# Context

<Link to the related issue, ticket, or task. Ask the user if it is not obvious from commits or branch name.>

# Description

<Brief description of the reason behind the code changes.>

# Changes

- <change 1>
- <change 2>

# Manual testing <optional>

<Steps reviewers should follow to manually test the changes.>
```

## Step 6: Show the User and Confirm

Present the PR title and body to the user. Ask if they want to adjust anything before creating the pull request.

## Step 7: Create the PR with `gh` (MANDATORY)

You MUST use the `gh` CLI to create the PR. Do NOT just output the template. Actually create the PR.

```bash
git push -u origin HEAD
gh pr create --base <base-branch> --title "<title>" --body "<body>"
```

After creation, show:

```text
Created PR #<number>: <title>
<pr_url>
```

## Troubleshooting

### `not logged into any GitHub hosts`

Tell the user to run:

```bash
gh auth login
```
