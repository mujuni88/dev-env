#!/usr/bin/env bun
import type { PreToolUseHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

const input: PreToolUseHookInput = JSON.parse(await Bun.stdin.text());

// Log tool use for debugging
console.error(`[PreToolUse] ${input.tool_name}`);

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
