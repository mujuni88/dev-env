#!/usr/bin/env bun
import type { StopHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

const input: StopHookInput = JSON.parse(await Bun.stdin.text());
const args = process.argv.slice(2);
const isChat = args.includes('--chat');

if (isChat) {
  console.error('[Stop] Chat session stopped');
}

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
