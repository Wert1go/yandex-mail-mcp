# Yandex Mail MCP Server

MCP (Model Context Protocol) server for Yandex Mail. Enables Claude Desktop and other MCP clients to read, search, and send emails via Yandex Mail.

## Features

- **List folders** — with decoded Russian folder names
- **Search emails** — by sender, subject, date, or custom IMAP queries (supports Cyrillic)
- **Read emails** — full content with text/HTML body
- **Download attachments** — save to disk
- **Send emails** — plain text or HTML
- **Move/Delete emails** — organize your mailbox

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/yandex-mail-mcp.git
cd yandex-mail-mcp

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Configure credentials
cp .env.example .env
# Edit .env with your Yandex email and app password
```

## Yandex Setup

1. Go to [Yandex ID](https://id.yandex.ru/)
2. Enable **Two-Factor Authentication** (required for app passwords)
3. Go to **Security → App Passwords**
4. Create new app password for "Mail"
5. Copy the generated password to `.env`

## Claude Desktop Configuration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "yandex-mail": {
      "command": "/path/to/yandex-mail-mcp/.venv/bin/python",
      "args": ["/path/to/yandex-mail-mcp/server.py"]
    }
  }
}
```

Restart Claude Desktop after configuration.

## Available Tools

| Tool | Description |
|------|-------------|
| `list_folders()` | List all mailbox folders |
| `search_emails(folder, query, limit)` | Search emails with IMAP queries |
| `read_email(folder, email_id)` | Read full email content |
| `download_attachment(folder, email_id, filename, save_dir)` | Download attachment to disk |
| `send_email(to, subject, body, cc, bcc, html)` | Send an email |
| `move_email(folder, email_id, destination)` | Move email to another folder |
| `delete_email(folder, email_id)` | Delete email (move to Trash) |

## Search Query Examples

```
ALL                          # All emails
UNSEEN                       # Unread emails
FROM sender@example.com      # From specific sender
SUBJECT hello                # Subject contains "hello"
SINCE 01-Dec-2024            # Emails since date
UNSEEN FROM boss@company.com # Combined query
```

## Running Tests

```bash
source .venv/bin/activate
pytest test_server.py -v
```

## Security (prompt injection + least privilege)

Email content is **untrusted input**. If you use an LLM agent (Cursor, Claude, etc.) to read emails and call tools, attackers can embed **prompt-injection** instructions inside email text/HTML.

### Recommended hardening

- **Use app passwords** (not your primary password) and enable 2FA in Yandex.
- **Protect `.env`**: keep it local-only and restrict file permissions (e.g. `chmod 600 .env` on macOS/Linux).
- **Least privilege tools by default**:
  - This server registers only read tools + `send_email` by default.
  - High-risk tools are **implemented but not exposed** unless you explicitly enable them:
    - `ENABLE_FILE_DOWNLOAD=1` for `download_attachment`
    - `ENABLE_MUTATIONS=1` for `move_email` / `delete_email`
- **Sending policy (strongly recommended)**:
  - Set `ALLOWED_RECIPIENT_DOMAINS` and/or `ALLOWED_RECIPIENTS` to prevent exfiltration via `send_email`.
  - Set `SEND_RATE_LIMIT_PER_MINUTE` and `MAX_SEND_BODY_CHARS`.
- **Reduce prompt-injection surface**:
  - Limit returned body size with `MAX_READ_BODY_CHARS`.
  - Treat `read_email` output as data; never follow instructions inside emails.
- **Detection / audit**:
  - Enable `ENABLE_INJECTION_LOGGING=1` to log suspicious prompt-injection *signals* detected in emails (logs metadata + signal names, not bodies).
  - `LOG_INJECTION_ONLY_IF_INSTRUCTION=1` reduces noise by logging only when “instructional” patterns are detected.
  - Optional: `INJECTION_BLOCK_SEND_ON_INSTRUCTION=1` blocks `send_email` for `INJECTION_BLOCK_WINDOW_SECONDS` after reading an email with instructional patterns.

## License

MIT
