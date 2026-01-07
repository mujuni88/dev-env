#!/usr/bin/env python3
"""
Claude Code Slack Notifier

A utility script that sends notifications to Slack when Claude Code completes tasks,
encounters errors, or needs user input. This integrates with Claude Code's hook system.
"""

import json
import sys
import os
import argparse
import subprocess
from datetime import datetime
from typing import Dict, Any, Optional
try:
    import urllib.request
    import urllib.parse
except ImportError:
    print("Error: Required modules not available", file=sys.stderr)
    sys.exit(1)


class SlackNotifier:
    def __init__(self, channel: str):
        """Initialize the Slack notifier with a Netflix channel/email."""
        self.channel = channel
        self.netflix_endpoint = 'http://openfaas.us-east-1.prod.netflix.net:7001/function/mli_hosting/endpoint/SlackWebService/prod/send_message'

    def send_notification(self, message_type: str, title: str, details: str,
                         context: Optional[Dict[str, Any]] = None,
                         source: str = "claude") -> bool:
        """
        Send a notification to Slack using Block Kit format.

        Args:
            message_type: Type of notification (success, error, input_needed)
            title: Main title for the notification
            details: Detailed message content
            context: Additional context information
            source: Which tool generated the notification (claude or codex)

        Returns:
            bool: True if notification sent successfully, False otherwise
        """

        emoji_map = {
            "success": "✅",
            "error": "❌",
            "input_needed": "⚠️",
            "info": "✨",
            "codex_complete": "🤖"
        }

        emoji = emoji_map.get(message_type, "🤖")

        # Build message for Netflix internal Slack service
        message_lines = [f"{emoji} *{title}*"]
        details_line = details.strip()
        if details_line:
            message_lines.append(details_line)

        # Add the originating tool's last message if available
        if source == "codex":
            thread_id = ""
            if context:
                thread_id = context.get('thread_id', '')
            agent_message = get_codex_last_message(thread_id)
        else:
            agent_message = get_claude_last_message()

        error_prefixes = (
            "Claude project directory not found",
            "No Claude session files found",
            "Error reading session file",
            "Error extracting Claude message",
            "Codex thread id missing",
            "Codex sessions directory not found",
            "No Codex session file found for this thread",
            "Error reading Codex session file",
            "Error extracting Codex message",
            "No recent Codex messages found"
        )

        has_agent_message = bool(agent_message) and not str(agent_message).startswith(error_prefixes)

        if not details_line and source == "codex" and has_agent_message:
            summary_line = summarize_agent_message(agent_message)
            if summary_line:
                message_lines.append(summary_line)

        if has_agent_message:
            label = "Codex's" if source == "codex" else "Claude's"
            message_lines.append(f"💬 *{label} last message:*\n```{agent_message}```")

        # Add context information if provided
        if context:
            context_parts = []
            if 'working_directory' in context:
                context_parts.append(f"📁 Directory: `{context['working_directory']}`")
            if 'git_branch' in context:
                context_parts.append(f"🌿 Branch: `{context['git_branch']}`")
            git_status_preview = context.get('git_status_preview')
            if git_status_preview:
                context_parts.append(f"📝 Changes:\n```{git_status_preview}```")
            if 'machine_identifier' in context:
                if context.get('is_dev_workspace'):
                    context_parts.append(f"☁️ Workspace: <{context['machine_identifier']}|{context.get('hostname', 'workspace')}>")
                else:
                    context_parts.append(f"💻 Machine: `{context['machine_identifier']}`")
            thread_url = context.get('thread_url')
            thread_id = context.get('thread_id')
            has_thread_id = bool(thread_id) and thread_id != "unknown"
            if thread_url:
                label = thread_id if has_thread_id else "open thread"
                context_parts.append(f"🧵 Thread: <{thread_url}|{label}>")
            elif has_thread_id:
                context_parts.append(f"🧵 Thread ID: `{thread_id}`")
            resume_command = context.get('resume_command')
            if resume_command:
                context_parts.append(f"▶️ Resume: `{resume_command}`")
            if context_parts:
                message_lines.append("\n".join(context_parts))

        # Create Netflix-format payload (Slack rejects empty strings, so strip them)
        payload = {
            "channel": self.channel,
            "message": [line for line in message_lines if line.strip()],
            "msg_type": "markdown"
        }

        try:
            # Use Netflix internal Slack service
            data = json.dumps(payload).encode('utf-8')
            req = urllib.request.Request(
                self.netflix_endpoint,
                data=data,
                headers={'Content-Type': 'application/json'}
            )

            with urllib.request.urlopen(req, timeout=10) as response:
                if response.getcode() == 200:
                    return True
                else:
                    return False
        except Exception as e:
            return False


def summarize_agent_message(message: Optional[str]) -> Optional[str]:
    """Return a short, single-line summary from the agent output."""
    if not message:
        return None
    text = message.strip()
    if not text:
        return None
    first_line = text.splitlines()[0].strip()
    if not first_line:
        return None
    max_len = 160
    if len(first_line) > max_len:
        first_line = first_line[: max_len - 3] + "..."
    return first_line


def get_claude_last_message() -> str:
    """Extract the last assistant message from Claude Code JSONL files."""
    try:
        import glob
        cwd = os.getcwd()

        # Map current directory to Claude Code project directory format
        # Replace / with - and add leading -
        project_dir = cwd.replace('/', '-')
        if not project_dir.startswith('-'):
            project_dir = '-' + project_dir

        claude_project_path = os.path.expanduser(f"~/.claude/projects/{project_dir}")

        if not os.path.exists(claude_project_path):
            return "Claude project directory not found"

        # Find the most recent JSONL file
        jsonl_files = glob.glob(os.path.join(claude_project_path, "*.jsonl"))
        if not jsonl_files:
            return "No Claude session files found"

        # Get the most recent file by modification time
        most_recent_file = max(jsonl_files, key=os.path.getmtime)

        # Extract the last assistant message with text content
        last_message = None
        try:
            with open(most_recent_file, 'r', encoding='utf-8') as f:
                for line in f:
                    try:
                        data = json.loads(line.strip())
                        if (data.get('type') == 'assistant' and
                            data.get('message', {}).get('role') == 'assistant'):

                            content = data.get('message', {}).get('content', [])
                            for item in content:
                                if item.get('type') == 'text' and item.get('text'):
                                    last_message = item.get('text')
                    except json.JSONDecodeError:
                        continue
        except Exception as e:
            return f"Error reading session file: {str(e)}"

        if last_message:
            # Truncate message if too long for Slack
            if len(last_message) > 500:
                last_message = last_message[:497] + "..."
            return last_message
        else:
            return "No recent Claude messages found"

    except Exception as e:
        return f"Error extracting Claude message: {str(e)}"


def get_codex_last_message(thread_id: str) -> str:
    """Extract the last assistant message from Codex CLI JSONL session files."""
    try:
        import glob

        if not thread_id:
            return "Codex thread id missing"

        codex_sessions_path = os.path.expanduser("~/.codex/sessions")
        if not os.path.exists(codex_sessions_path):
            return "Codex sessions directory not found"

        pattern = os.path.join(codex_sessions_path, "**", f"*{thread_id}.jsonl")
        matching_files = glob.glob(pattern, recursive=True)
        if not matching_files:
            return "No Codex session file found for this thread"

        session_file = matching_files[0]
        last_message = None
        try:
            with open(session_file, 'r', encoding='utf-8') as f:
                for line in f:
                    try:
                        data = json.loads(line.strip())
                    except json.JSONDecodeError:
                        continue

                    payload = data.get('payload', {})
                    if (
                        data.get('type') == 'response_item' and
                        payload.get('type') == 'message' and
                        payload.get('role') == 'assistant'
                    ):
                        content = payload.get('content', [])
                        for item in content:
                            if item.get('type') == 'output_text' and item.get('text'):
                                last_message = item.get('text')
        except Exception as e:
            return f"Error reading Codex session file: {str(e)}"

        if last_message:
            if len(last_message) > 500:
                last_message = last_message[:497] + "..."
            return last_message
        else:
            return "No recent Codex messages found"

    except Exception as e:
        return f"Error extracting Codex message: {str(e)}"


def get_machine_info() -> Dict[str, str]:
    """Get machine hostname and whether it's a dev workspace."""
    import socket
    import os

    hostname = socket.gethostname()
    is_dev_workspace = bool(os.environ.get('CODER'))

    if is_dev_workspace:
        owner = os.environ.get('CODER_WORKSPACE_OWNER_NAME', 'unknown')
        workspace_name = os.environ.get('CODER_WORKSPACE_NAME', hostname)
        machine_identifier = f"https://console.netflix.net/workspaces/@{owner}/workspace/{workspace_name}"
    else:
        machine_identifier = hostname

    return {
        'hostname': hostname,
        'is_dev_workspace': is_dev_workspace,
        'machine_identifier': machine_identifier
    }


def get_git_info() -> Dict[str, str]:
    """Get current git branch and repository information."""
    info: Dict[str, str] = {}
    try:
        branch = subprocess.check_output(
            ['git', 'branch', '--show-current'],
            stderr=subprocess.DEVNULL,
            text=True
        ).strip()
        if branch:
            info['git_branch'] = branch
    except Exception:
        pass

    try:
        status_output = subprocess.check_output(
            ['git', 'status', '--short'],
            stderr=subprocess.DEVNULL,
            text=True
        ).strip()
        if status_output:
            preview = "\n".join(status_output.splitlines()[:5])
            info['git_status_preview'] = preview
    except Exception:
        pass

    return info


def main():
    parser = argparse.ArgumentParser(description='Send Slack notifications from Claude Code')
    parser.add_argument('--channel', required=True,
                       help='Netflix email or channel for notifications (e.g., araman@netflix.com)')
    parser.add_argument('--type', choices=['success', 'error', 'input_needed', 'info', 'codex_complete'],
                       default='info', help='Type of notification')
    parser.add_argument('--title', required=True,
                       help='Notification title')
    parser.add_argument('--message', required=True,
                       help='Notification message')
    parser.add_argument('--context',
                       help='Additional context as JSON string')
    parser.add_argument('--source', choices=['claude', 'codex'],
                       default='claude', help='Source tool that triggered the notification')

    args = parser.parse_args()

    # Parse context if provided
    context = {}
    if args.context:
        try:
            parsed_context = json.loads(args.context)
            # Ensure context is a dictionary
            if isinstance(parsed_context, dict):
                context = parsed_context
            else:
                print("Warning: Context parameter is not a JSON object", file=sys.stderr)
                context = {}
        except json.JSONDecodeError:
            print("Warning: Invalid JSON in context parameter", file=sys.stderr)
            context = {}

    if not context.get('working_directory'):
        context['working_directory'] = os.getcwd()
    context['timestamp'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    context.update(get_git_info())
    context.update(get_machine_info())

    # Send notification
    notifier = SlackNotifier(args.channel)
    success = notifier.send_notification(
        message_type=args.type,
        title=args.title,
        details=args.message,
        context=context,
        source=args.source
    )

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
