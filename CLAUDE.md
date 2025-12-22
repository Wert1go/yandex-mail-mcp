# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MCP (Model Context Protocol) server for Yandex Mail. Provides 7 email tools via IMAP/SMTP that can be used by any MCP-compatible client.

## Commands

```bash
# Setup
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run tests
pytest test_server.py -v

# Run single test
pytest test_server.py::TestSearchEmails::test_search_by_from_address -v

# Test server directly (imports and runs a function)
python -c "from server import list_folders; print(list_folders())"
```

## Architecture

Single-file MCP server (`server.py`) using FastMCP framework:

- **Connection helpers**: `imap_connection()` and `smtp_connection()` context managers handle auth and cleanup
- **IMAP tools**: `list_folders`, `search_emails`, `read_email`, `download_attachment`, `move_email`, `delete_email`
- **SMTP tools**: `send_email`
- **Encoding helpers**: `decode_mime_header()` for email headers, `decode_folder_name()` for IMAP UTF-7 folder names (Russian)

Key implementation details:
- `.env` loaded from script directory (not CWD) to work when launched by MCP clients
- Logging to file (`yandex_mail_mcp.log`) because stdout is reserved for MCP protocol
- Cyrillic search uses UTF-8 charset in IMAP SEARCH command
- IMAP search queries need proper quoting via `build_imap_search_criteria()`

## Testing

Tests are integration tests against a live Yandex mailbox. Requires valid credentials in `.env`. Some tests may fail due to Yandex rate limiting when running full suite.

## Release

Use `/version X.Y.Z` command to release a new version. It updates `VERSION` in server.py, creates CHANGELOG.md entry, commits, tags, and pushes.
