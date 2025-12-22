# Claude Desktop Setup

Quick guide to configure Yandex Mail MCP for Claude Desktop.

## Prerequisites

1. Complete the [Installation](README.md#installation) steps
2. Have your `.env` file configured with Yandex credentials

## Configuration

### macOS

Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "yandex-mail": {
      "command": "/absolute/path/to/yandex-mail-mcp/.venv/bin/python",
      "args": ["/absolute/path/to/yandex-mail-mcp/server.py"]
    }
  }
}
```

### Windows

Edit `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "yandex-mail": {
      "command": "C:\\path\\to\\yandex-mail-mcp\\.venv\\Scripts\\python.exe",
      "args": ["C:\\path\\to\\yandex-mail-mcp\\server.py"]
    }
  }
}
```

## Verify Installation

1. Restart Claude Desktop (Cmd+Q / Alt+F4, then reopen)
2. Look for "yandex-mail" in the MCP servers list
3. Try asking Claude: "List my email folders"

## Troubleshooting

### Server disconnected

Check logs at:
- macOS: `~/Library/Logs/Claude/mcp*.log`
- Windows: `%APPDATA%\Claude\logs\mcp*.log`

Common issues:
- Wrong Python path (use absolute path to `.venv/bin/python`)
- Missing `.env` file in project directory
- Invalid Yandex credentials

### Tools not appearing

- Ensure Claude Desktop is fully restarted
- Check that the config JSON is valid (no trailing commas)
