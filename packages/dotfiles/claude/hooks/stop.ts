#!/usr/bin/env bun
import type { StopHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

let input: StopHookInput;
try {
  const stdin = await Bun.stdin.text();
  input = stdin ? JSON.parse(stdin) : {};
} catch {
  input = {};
}

const args = process.argv.slice(2);
const isChat = args.includes('--chat');

if (isChat) {
  console.error('[Stop] Chat session stopped');
}

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
