#!/usr/bin/env bun
import type { NotificationHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';

const input: NotificationHookInput = JSON.parse(await Bun.stdin.text());
const args = process.argv.slice(2);
const shouldNotify = args.includes('--notify');

if (shouldNotify) {
  // Send macOS notification
  const title = input.title || 'Claude Code';
  const message = input.message;

  const proc = Bun.spawn([
    'osascript',
    '-e',
    `display notification "${message.replace(/"/g, '\\"')}" with title "${title.replace(/"/g, '\\"')}"`
  ]);

  await proc.exited;
}

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
