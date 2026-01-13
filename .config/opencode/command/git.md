---
description: Auto commit - check branch, stage changes, and commit
model: google/gemini-3-flash-preview
---

You have access to these Git workflow tools: `git-status`, `git-branch`, and `git-commit`.

Perform this automated Git workflow with NO user input required:

## Step 1: Check branch
Use `git-status` to check the current branch.

- If on `main` or `master`: You MUST create a new branch first using `git-branch`. Analyze the staged/unstaged changes to determine an appropriate branch name and type (feature/, fix/, chore/, etc.).
- If already on a feature/fix/etc branch: Continue to step 2.

## Step 2: Stage and commit
Look at the changes from git-status:
- If there are unstaged or untracked files: Use `git-commit` with `stageAll: true`
- Analyze the changes to determine the appropriate commit type (feat, fix, docs, refactor, chore, etc.)
- Write a clear, concise commit message describing what changed
- Use an appropriate scope if the changes are focused on a specific area

## Rules
- Do NOT ask the user anything - make smart decisions automatically
- Branch names should be descriptive kebab-case based on the changes
- Commit messages should be in imperative mood ("add feature" not "added feature")
- If there are no changes to commit, just report that the working tree is clean

## Semantic naming reference
- Branch types: feature, fix, bugfix, hotfix, chore, docs, refactor, test, ci, build, perf, style, revert
- Commit types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
