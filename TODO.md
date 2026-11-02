# ✅ TODO — Cloudflare Origin Cert Demo

Tracks the current round of requested changes. See [`SOP.md`](SOP.md) for the step-by-step procedure these were implemented against.

## This round (2026-11-02)

- [x] Add the live fly.io site link to `README.md` (intro section + References)
- [x] Make every Mermaid diagram in `index.html` clickable, opening in a new tab:
  - [x] Big-picture flowchart (§1) — 3 nodes
  - [x] Sequence diagram (§2) — 4 actors, via `link` directive
  - [x] Dashboard flowchart (§4) — 8 nodes
  - [x] Verification flowchart (§7) — 4 nodes
- [x] Enable `securityLevel: "loose"` in `mermaid.initialize()` (required for clicks to work at all)
- [x] Add a visible hint telling readers the diagrams are clickable
- [x] Create `SOP.md` (standard operating procedure for this repo's visual-docs changes)
- [x] Create this `TODO.md` and keep it as the live progress tracker
- [ ] Redeploy `index.html` to fly.io (`flyctl deploy --remote-only`)
- [ ] Verify the live site serves the updated page (curl check + manual click-test of one diagram)
- [ ] Commit and push README.md, index.html, SOP.md, TODO.md to GitHub

## Round 2 (2026-11-02) — origin install + Fly.io worked example

- [x] Add §8 "Worked example — installing the cert on a Fly.io origin" to `README.md` and `index.html`
- [x] Build `origin-flyio/` (`Dockerfile`, `entrypoint.sh`, `nginx.conf`, `fly.origin.toml`) — nginx Machine that terminates TLS itself with the Origin CA cert, Fly does raw TCP passthrough only
- [x] Build `scripts/04-install-cert-flyio-origin.sh` — prints the exact `flyctl`/Cloudflare commands; does **not** provision or bill anything on its own
- [x] Use your real API Tokens page link (`https://dash.cloudflare.com/3683d1886e0a3a3152242c84f226ba3f/api-tokens`) in both docs, in place of the generic dashboard link
- [x] Add emojis throughout the new content
- [x] Make the new §8 diagram clickable too (7 nodes, all `_blank`)
- [x] Redeploy `index.html` to fly.io (round 2)

## Round 3 (2026-11-02) — plain-English rationale page

- [x] Write `RATIONALE.md` — layman's-terms explanation (office/reception/badge analogy)
- [x] Build `rationale.html` — same content, visual/dark-mode, matching `index.html` style, clickable diagrams
- [x] Link it from `index.html` (header + footer) and `README.md`
- [x] Update `Dockerfile` to serve `rationale.html` too
- [ ] Redeploy to fly.io (round 3, includes rationale.html)
- [ ] Verify `https://cloudflare-origin-cert-demo.fly.dev/rationale.html` returns 200
- [ ] Commit + push rounds 2 & 3 to GitHub

## Deferred / optional (not started — needs your input or your go-ahead to spend money)

- [ ] Actually run `scripts/04-install-cert-flyio-origin.sh`'s printed commands — step 4 allocates a **dedicated Fly.io IPv4 (~$2/month)**, not done without your OK
- [ ] Issue a **real** Cloudflare Origin CA certificate against a live domain on `contact@rifaterdemsahin.com` — needs: (a) which domain, (b) the Origin CA Key exported as `CF_ORIGIN_CA_KEY`
- [ ] Point a real domain's DNS at the Fly.io origin and flip Cloudflare SSL/TLS mode to Full (strict) end-to-end
