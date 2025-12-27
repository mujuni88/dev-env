#!/usr/bin/env bun
import type { SubagentStopHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

const input: SubagentStopHookInput = JSON.parse(await Bun.stdin.text());

console.error('[SubagentStop] Subagent stopped');

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
