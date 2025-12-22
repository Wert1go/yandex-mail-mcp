# Version Release Command

Release version: **%1**

## Steps

1. **Update VERSION in server.py**
   - Find `VERSION = "x.x.x"` constant near the top of server.py
   - Change to `VERSION = "%1"`
   - If VERSION doesn't exist, add it after the imports: `VERSION = "%1"`

2. **Update CHANGELOG.md**
   - Get previous version tag (latest v* tag)
   - Get all commits since previous version tag
   - Add new section at top of CHANGELOG.md: `## [%1] - {today's date in YYYY-MM-DD format}`
   - If CHANGELOG.md doesn't exist, create it with header:
     ```
     # Changelog
     All notable changes to this project will be documented in this file.
     ```
   - Organize changes by type:
     - Added: New features or functionality
     - Changed: Changes to existing functionality
     - Fixed: Bug fixes
     - Documentation: Documentation changes
   - Write clear, user-focused descriptions

3. **Commit all changes**
   - Commit ALL changes (including any uncommitted work)
   - Use commit message: `chore: Release version %1`
   - Create annotated git tag: `v%1` with message `Release version %1`

4. **Push to remote**
   - Push commits: `git push origin main`
   - Push the tag: `git push origin v%1`

## Important Notes

- If no previous version tag exists, include all commits
- Use today's date in YYYY-MM-DD format
- Tag should be annotated (git tag -a) not lightweight
