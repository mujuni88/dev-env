#!/usr/bin/env bun
import type { SessionStartHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';
import { execSync } from 'child_process';

const input: SessionStartHookInput = JSON.parse(await Bun.stdin.text());

let beadsContext = '';

try {
  // Check if beads is initialized in the current working directory
  const info = execSync('bd info --json 2>/dev/null', {
    cwd: input.cwd,
    encoding: 'utf8',
    timeout: 5000,
  });

  if (info) {
    // Beads is initialized, get the prime context
    try {
      beadsContext = execSync('bd prime 2>/dev/null', {
        cwd: input.cwd,
        encoding: 'utf8',
        timeout: 5000,
      });
    } catch {
      // bd prime failed, get basic ready work info
      try {
        const ready = execSync('bd ready --json 2>/dev/null', {
          cwd: input.cwd,
          encoding: 'utf8',
          timeout: 5000,
        });
        const readyIssues = JSON.parse(ready);
        if (readyIssues.length > 0) {
          beadsContext = `\n## Beads: Ready Work\n${readyIssues.length} issue(s) ready to work on. Run \`bd ready\` for details.\n`;
        }
      } catch {
        // Ignore errors
      }
    }
  }
} catch {
  // Beads not initialized in this project - that's fine
}

const output: SyncHookJSONOutput = {
  continue: true,
  ...(beadsContext && {
    context: {
      name: 'beads-context',
      content: beadsContext,
    },
  }),
};

console.log(JSON.stringify(output));
