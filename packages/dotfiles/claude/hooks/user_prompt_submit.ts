#!/usr/bin/env bun
import type { UserPromptSubmitHookInput, SyncHookJSONOutput } from '@anthropic-ai/claude-code/sdk';
import { existsSync } from 'fs';
import { mkdir, appendFile } from 'fs/promises';
import { join, dirname } from 'path';

const input: UserPromptSubmitHookInput = JSON.parse(await Bun.stdin.text());
const args = process.argv.slice(2);
const logOnly = args.includes('--log-only');

if (logOnly) {
  // Log user prompts to a file
  const logDir = join(process.env.HOME || '~', '.claude', 'hooks');
  const logFile = join(logDir, 'prompts.log');

  if (!existsSync(logDir)) {
    await mkdir(logDir, { recursive: true });
  }

  const timestamp = new Date().toISOString();
  const logEntry = `[${timestamp}] ${input.prompt}\n\n`;

  await appendFile(logFile, logEntry);
}

const output: SyncHookJSONOutput = {
  continue: true,
};

console.log(JSON.stringify(output));
