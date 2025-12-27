#!/usr/bin/env bun
import type { PostToolUseHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

const input: PostToolUseHookInput = JSON.parse(await Bun.stdin.text());

// Log tool use completion
console.error(`[PostToolUse] ${input.tool_name} completed`);

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
