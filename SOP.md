# 📋 SOP — Updating & Shipping the Visual Docs

**Scope:** `README.md` and `index.html` in this repo (the Cloudflare Origin CA demo). Use this whenever you add live links, make diagrams interactive, or otherwise touch the visual walkthrough — so changes are verified and shipped the same way every time.

**Owner:** `rifaterdemsahin` · **Cloudflare account referenced:** `contact@rifaterdemsahin.com` · **Live site:** https://cloudflare-origin-cert-demo.fly.dev/

---

## 1. Procedure

| # | Step | Command / Action | Done when |
|---|------|-------------------|-----------|
| 1 | Read current state | `Read README.md`, `Read index.html` | You know exact line numbers to change |
| 2 | Edit `README.md` | Add/update links, sections | Markdown preview (GitHub or Obsidian) renders correctly |
| 3 | Edit `index.html` | Add Mermaid `click` (flowcharts) / `link` (sequence diagrams) directives; set `securityLevel: "loose"` in `mermaid.initialize()` | Diagram syntax is valid Mermaid |
| 4 | Lint shell changes (if any) | `bash -n scripts/*.sh` | No syntax errors |
| 5 | Local sanity check | `grep -c "click \|link " index.html` → confirm new directives present | Count matches what you added |
| 6 | Deploy | `flyctl deploy --remote-only` (from repo root, `fly.toml` present) | Deploy reports "success" and gives the app URL |
| 7 | Verify live | `curl -s -o /dev/null -w "%{http_code}" https://cloudflare-origin-cert-demo.fly.dev/` → `200` | HTTP 200 returned |
| 8 | Visual check | Open the live URL, click one node in each diagram, confirm it opens a new tab to a working URL | No dead links, no same-tab navigation away from the demo |
| 9 | Commit | `git add README.md index.html SOP.md TODO.md`, `git commit -m "..."` | `git status` clean, no secrets staged |
| 10 | Push | `git push origin main` | Push succeeds, GitHub shows the new commit |
| 11 | Update tracker | Tick the matching boxes in `TODO.md` | TODO reflects reality |

## 2. Guardrails (don't skip these)

- **Never commit secrets.** `.gitignore` already excludes `*.key`, `*.csr`, `*.pem`, `.env` — don't override that.
- **Never provision billable infra silently.** Allocating a dedicated Fly.io IPv4 (used by the §8 Fly.io origin example) costs ~$2/month. Scripts that would spend money (`scripts/04-install-cert-flyio-origin.sh`) only *print* the commands — they don't run them. Get explicit go-ahead before actually running those commands.
- **Mermaid `securityLevel`:** clicks/links are silently ignored unless `securityLevel: "loose"` is set — check this first if a diagram click does nothing.
- **Target `_blank` on every link** added to diagrams, so the live demo page is never navigated away from.
- **Verify before reporting done:** a deploy succeeding is not the same as the page being correct — always `curl` + visually click-test after deploying.
- **Keep README and index.html in sync** — they describe the same flow; a change to one (new step, new link) should be mirrored in the other unless it's HTML-only (styling, interactivity).

## 3. Progress tracking

Use `TODO.md` in this repo as the single live checklist for in-flight work. This SOP is the *procedure*; `TODO.md` is the *state*. When starting new work:

1. Add new unchecked items to `TODO.md` under a new dated section.
2. Work through steps 1–11 above.
3. Check items off as they complete — don't batch-check at the end, so a partially-done round is visible if interrupted.

## 4. Rollback

If a deploy breaks the live page:

```bash
git log --oneline -5          # find the last known-good commit
git revert <bad-commit>       # or: git checkout <good-commit> -- index.html
flyctl deploy --remote-only   # redeploy the reverted version
```
