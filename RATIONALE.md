# 🤔 Why bother with an Origin CA certificate? (plain-English version)

No jargon first — read this before the README if the technical version doesn't click.

## 🏢 Think of your website like an office building

- **Cloudflare is the reception desk** at the front of the building. Every visitor talks to reception first.
- **Your origin server** (the actual app, on Fly.io, a VPS, wherever) is the **back office**, behind a door reception can reach but the public can't.

## 🔒 Lock #1: Visitor ↔ Reception (already solved, not your problem)

When someone visits your site, their browser and Cloudflare's reception desk talk over a **locked, sealed line** — that's the padlock 🔒 you see in the browser address bar. Cloudflare provides and manages this automatically. **You don't do anything for this one.**

## 🚪 Lock #2: Reception ↔ Back Office (this is the gap)

Here's the part people miss: **reception still has to walk down a hallway to reach the back office.** If that hallway is unlocked:

- Anyone with access to the building's internal hallway could **eavesdrop** on what reception is telling the back office.
- Someone could **impersonate the back office**, and reception would have no way to tell it wasn't really talking to you.

That hallway is the connection between **Cloudflare's edge and your origin server**. By default, nothing forces it to be locked.

## 🪪 What the Origin CA certificate actually is

It's a **special ID badge** that only Cloudflare issues, and only Cloudflare trusts. You put this badge on your back-office door (your origin server). Now:

- Reception (Cloudflare) checks the badge every time before handing over any visitor's data.
- Nobody else can forge that badge, because only Cloudflare's own badge-printing machine made it.
- The public never needs to see or trust this badge — it's an **internal-only pass**, which is why it can be valid for up to **15 years** instead of the ~90 days public certificates usually last.

## 🙅 "Why not just use a random self-signed certificate?"

You could put *any* lock on the back-office door. But if it's a lock you made yourself (a self-signed cert), reception has no way to know it's genuinely yours and not an impostor's. Cloudflare's strictest mode ("Full (strict)") **refuses to trust a lock it didn't issue or recognize** — which is exactly the point: it stops anyone from sneaking a fake back office into the hallway.

## 🧪 What this repo actually demonstrates

| Everyday idea | What's really happening | Where in this repo |
|---|---|---|
| 🧾 Request a badge | Generate a CSR, send it to Cloudflare | `scripts/01-generate-csr.sh`, `scripts/02-request-origin-cert.sh` |
| 🪪 Pin the badge to the back-office door | Install the cert on the origin's nginx | `nginx/origin.conf.example`, `origin-flyio/` |
| 🔐 Tell reception to always check badges | Switch Cloudflare's SSL mode to **Full (strict)** | README §5 / §8 |
| 🕵️ Double-check the badge is real | `scripts/03-verify.sh` | Confirms the issuer is Cloudflare, not self-signed |
| 🛫 A worked, runnable back office | A Fly.io Machine standing in for a real origin server | `origin-flyio/`, `scripts/04-install-cert-flyio-origin.sh` |

## 😬 What happens if you skip this

Without an Origin CA cert, you're forced into Cloudflare's **"Flexible"** SSL mode: the front door is locked, but the internal hallway isn't. Visitor traffic looks secure in the browser, but it travels **in the clear** between Cloudflare and your server — anyone who can reach that hallway (a misconfigured network, a compromised host nearby, certain man-in-the-middle setups) can read or alter it. The Origin CA cert closes that gap for the cost of ten minutes of setup.

---

🔗 See [`README.md`](README.md) for the technical, step-by-step version, or the live visual walkthrough at **[cloudflare-origin-cert-demo.fly.dev](https://cloudflare-origin-cert-demo.fly.dev/)**.
