import type { Plugin } from "@opencode-ai/plugin";
import { tool } from "@opencode-ai/plugin";

/**
 * Git Workflow Plugin for OpenCode
 * Provides tools for: branch creation, commits, status, and push
 */
export const GitWorkflowPlugin: Plugin = async ({ $ }) => {
  return {
    tool: {
      "git-branch": tool({
        description:
          "Create a new Git branch with semantic naming. Types: feature, fix, bugfix, hotfix, chore, docs, refactor, test, ci, build, perf, style, revert. Format: <type>/<description>",
        args: {
          type: tool.schema
            .enum([
              "feature",
              "fix",
              "bugfix",
              "hotfix",
              "chore",
              "docs",
              "refactor",
              "test",
              "ci",
              "build",
              "perf",
              "style",
              "revert",
            ])
            .describe("Branch type prefix"),
          description: tool.schema
            .string()
            .describe("Branch description in kebab-case (e.g., add-user-auth)"),
          base: tool.schema
            .string()
            .optional()
            .describe("Base branch to create from (defaults to current)"),
        },
        async execute(args) {
          const branchName = `${args.type}/${args.description}`;

          const currentBranch = await $`git rev-parse --abbrev-ref HEAD`.text();

          if (args.base) {
            await $`git checkout ${args.base}`;
          }

          await $`git checkout -b ${branchName}`;

          return `Created branch: ${branchName}\nPrevious: ${currentBranch.trim()}`;
        },
      }),

      "git-commit": tool({
        description:
          "Create a commit with conventional format. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert. Format: <type>(<scope>): <message>",
        args: {
          type: tool.schema
            .enum([
              "feat",
              "fix",
              "docs",
              "style",
              "refactor",
              "perf",
              "test",
              "build",
              "ci",
              "chore",
              "revert",
            ])
            .describe("Commit type"),
          message: tool.schema
            .string()
            .describe("Commit message in imperative mood"),
          scope: tool.schema
            .string()
            .optional()
            .describe("Scope of change (e.g., auth, api)"),
          body: tool.schema
            .string()
            .optional()
            .describe("Extended commit body"),
          stageAll: tool.schema
            .boolean()
            .optional()
            .describe("Stage all changes before commit"),
        },
        async execute(args) {
          if (args.stageAll) {
            await $`git add -A`;
          }

          const staged = await $`git diff --cached --name-only`.text();
          if (!staged.trim()) {
            return "No staged changes. Use stageAll: true or stage files first.";
          }

          const scopePart = args.scope ? `(${args.scope})` : "";
          const title = `${args.type}${scopePart}: ${args.message}`;

          if (args.body) {
            await $`git commit -m ${title} -m ${args.body}`;
          } else {
            await $`git commit -m ${title}`;
          }

          const hash = await $`git rev-parse --short HEAD`.text();

          return `Commit ${hash.trim()}: ${title}\nFiles: ${staged.trim()}`;
        },
      }),

      "git-status": tool({
        description: "Check Git repository status with branch and tracking info",
        args: {
          verbose: tool.schema
            .boolean()
            .optional()
            .describe("Show detailed diff stats"),
        },
        async execute(args) {
          const branch = await $`git rev-parse --abbrev-ref HEAD`.text();
          const status = await $`git status --short`.text();

          let tracking = "No upstream configured";
          try {
            const upstream =
              await $`git rev-parse --abbrev-ref @{upstream}`.text();
            const ahead = await $`git rev-list --count @{upstream}..HEAD`.text();
            const behind =
              await $`git rev-list --count HEAD..@{upstream}`.text();
            tracking = `${upstream.trim()} (ahead: ${ahead.trim()}, behind: ${behind.trim()})`;
          } catch {
            // No upstream
          }

          let lastCommit = "No commits yet";
          try {
            lastCommit = await $`git log -1 --format="%h %s"`.text();
          } catch {
            // No commits
          }

          let result = `Branch: ${branch.trim()}\nTracking: ${tracking}\nLast commit: ${lastCommit.trim()}\n\nStatus:\n${status.trim() || "Working tree clean"}`;

          if (args.verbose && status.trim()) {
            try {
              const stagedDiff = await $`git diff --cached --stat`.text();
              const unstagedDiff = await $`git diff --stat`.text();
              if (stagedDiff.trim()) {
                result += `\n\nStaged:\n${stagedDiff.trim()}`;
              }
              if (unstagedDiff.trim()) {
                result += `\n\nUnstaged:\n${unstagedDiff.trim()}`;
              }
            } catch {
              // Ignore diff errors
            }
          }

          return result;
        },
      }),

      "git-push": tool({
        description: "Push commits to upstream remote branch",
        args: {
          setUpstream: tool.schema
            .boolean()
            .optional()
            .describe("Set upstream tracking (-u flag)"),
          remote: tool.schema
            .string()
            .optional()
            .describe("Remote name (default: origin)"),
          force: tool.schema
            .boolean()
            .optional()
            .describe("Force push with lease"),
        },
        async execute(args) {
          const remote = args.remote || "origin";
          const branch = await $`git rev-parse --abbrev-ref HEAD`.text();
          const branchName = branch.trim();

          const pushArgs: string[] = ["git", "push"];

          if (args.setUpstream) {
            pushArgs.push("-u", remote, branchName);
          }

          if (args.force) {
            pushArgs.push("--force-with-lease");
          }

          if (args.setUpstream) {
            if (args.force) {
              await $`git push -u ${remote} ${branchName} --force-with-lease`;
            } else {
              await $`git push -u ${remote} ${branchName}`;
            }
          } else {
            if (args.force) {
              await $`git push --force-with-lease`;
            } else {
              await $`git push`;
            }
          }

          return `Pushed to ${remote}/${branchName}${args.setUpstream ? " (upstream set)" : ""}${args.force ? " (force)" : ""}`;
        },
      }),
    },
  };
};
