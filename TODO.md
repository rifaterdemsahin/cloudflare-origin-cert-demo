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
- [x] Redeploy `index.html` to fly.io (`flyctl deploy --remote-only`)
- [x] Verify the live site serves the updated page (curl check + manual click-test of one diagram)
- [x] Commit and push README.md, index.html, SOP.md, TODO.md to GitHub

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
- [x] Redeploy to fly.io (round 3, includes rationale.html)
- [x] Verify `https://cloudflare-origin-cert-demo.fly.dev/rationale.html` returns 200
- [x] Commit + push rounds 2 & 3 to GitHub (commit `cd45dae`)

## Round 4 (2026-11-03) — Origin CA Key (Service Key) deprecation & API Token migration

- [x] Update `.env.example` from `CF_ORIGIN_CA_KEY` to `CF_API_TOKEN` (`Zone > SSL and Certificates > Edit`)
- [x] Update `scripts/02-request-origin-cert.sh` to authenticate with `Authorization: Bearer $CF_API_TOKEN` (replacing deprecated `X-Auth-User-Service-Key`) and warn if `CF_ORIGIN_CA_KEY` is still used
- [x] Update `README.md` (§3 Credentials, §4 Method A, §5 Method B, Security notes, References) with the September 30, 2026 Origin CA Key removal notice, API Token permissions table (`Zone > SSL and Certificates > Edit`), and Keyless SSL migration steps (`gokeyless >= 1.18.0`)
- [x] Update `index.html` to mirror all Origin CA Key deprecation & API Token (`Zone > SSL and Certificates > Edit`) changes
- [x] Lint shell scripts (`bash -n scripts/*.sh`)

## Round 5 (2026-11-03) — Two Ways to Create & Manage Origin CA Certificates (UI vs API)

- [x] Create `create-certificate.html` with side-by-side comparison of Option 1 (Dashboard UI - still fully available) and Option 2 (REST API with API Token)
- [x] Document the 4 API operations (`POST`, `GET`, `GET :id`, `DELETE :id`) and Cloudflare permissions (`Zone > SSL and Certificates > Edit`)
- [x] Link `create-certificate.html` in `index.html`, `rationale.html`, and `README.md`
- [x] Update `Dockerfile` to copy `create-certificate.html`
- [x] Verify local server returns HTTP 200 on `http://localhost:30081/create-certificate.html`
- [x] Open `http://localhost:30081/create-certificate.html` in Google Chrome

## Round 6 (2026-11-03) — Embed Screenshots with Modal Popups

- [x] Copy 7 recent screenshots from `~/Downloads/` to `images/`:
  - `Token-Generated-1.png`
  - `Asked-to-AI-to-learn-how-to-set-the-certificate-1.png`
  - `Origin-Server-Creation-Menu-1.png`
  - `Create-Certificate-Button-1.png`
  - `Create-Certificate-and-Selected-Domains-1.png`
  - `Pem-Format-Selection-With-Validity-1.png`
  - `Validate-Expiry-and-Creation-1.png`
- [x] Add `images/` directory to `Dockerfile`
- [x] Add accessible modal popup component (`#imageModal`, overlay, zoom animations, Escape key handler) in `index.html`
- [x] Embed inline modal triggers at each corresponding step in Section 3, Section 4, and Section 7
- [x] Add an interactive "Step-by-Step Screenshot Gallery" in Section 4
- [x] Verify local server serves all images and pages (HTTP 200)
- [x] Open `http://localhost:30081/index.html` in Google Chrome

## Deferred / optional (not started — needs your input or your go-ahead to spend money)

- [ ] Actually run `scripts/04-install-cert-flyio-origin.sh`'s printed commands — step 4 allocates a **dedicated Fly.io IPv4 (~$2/month)**, not done without your OK
- [x] Create API Token with `Zone > SSL and Certificates > Edit` and store in Azure Key Vault (`dp-kv-deliverypilot/secrets/cloudflare-origin-cert-api-token`)
- [x] Save Cloudflare Origin CA certificate and private key for `rifaterdemsahin.com` to Azure Key Vault:
  - `dp-kv-deliverypilot/secrets/cloudflare-origin-cert-rifaterdemsahin-com`
  - `dp-kv-deliverypilot/secrets/cloudflare-origin-key-rifaterdemsahin-com`
- [ ] Point domain DNS at the Fly.io origin and flip Cloudflare SSL/TLS mode to Full (strict) end-to-end
