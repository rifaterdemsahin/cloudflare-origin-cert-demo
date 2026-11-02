#!/usr/bin/env bash
# 🛫 Installs the Origin CA cert generated in steps 01/02 onto a Fly.io
# Machine acting as the "origin server", so you can see the full
# Cloudflare -> origin TLS hop working end to end.
#
# ⚠️ This allocates a SECOND Fly app and, if you run the optional dedicated-IPv4
#    command this script prints, that IPv4 is billed by Fly.io (~$2/month).
#    This script does NOT allocate an IP or deploy anything by itself —
#    it only prepares secrets + prints the exact commands to run yourself.
set -euo pipefail

OUT_DIR="${OUT_DIR:-./out}"
FLY_ORIGIN_APP="${FLY_ORIGIN_APP:-cloudflare-origin-cert-demo-origin}"
ORIGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)/origin-flyio"

CERT_FILE="$OUT_DIR/origin.pem"
KEY_FILE="$OUT_DIR/origin.key"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "❌ Missing $CERT_FILE / $KEY_FILE — run scripts/01-generate-csr.sh and scripts/02-request-origin-cert.sh first." >&2
  exit 1
fi

echo "🔐 Found origin cert + key in $OUT_DIR"
echo
echo "👉 1. Create the Fly app (one-time):"
echo "   flyctl apps create $FLY_ORIGIN_APP --org personal"
echo
echo "👉 2. Upload the cert + key as Fly secrets:"
echo "   flyctl secrets set \\"
echo "     ORIGIN_CERT_B64=\"\$(base64 < $CERT_FILE)\" \\"
echo "     ORIGIN_KEY_B64=\"\$(base64 < $KEY_FILE)\" \\"
echo "     -a $FLY_ORIGIN_APP"
echo
echo "👉 3. Deploy the origin image (nginx terminates TLS itself):"
echo "   flyctl deploy --remote-only -a $FLY_ORIGIN_APP -c \"$ORIGIN_DIR/fly.origin.toml\" --dockerfile \"$ORIGIN_DIR/Dockerfile\""
echo
echo "👉 4. Get a dedicated IPv4 (💰 ~\$2/month on Fly.io — confirm before running):"
echo "   flyctl ips allocate-v4 -a $FLY_ORIGIN_APP"
echo "   flyctl ips list -a $FLY_ORIGIN_APP"
echo
echo "👉 5. In Cloudflare DNS (dash.cloudflare.com), add an A record for your"
echo "   hostname -> that IPv4, proxy status 🟠 Proxied."
echo
echo "👉 6. SSL/TLS -> Overview -> set mode to Full (strict)."
echo
echo "👉 7. Verify end to end:"
echo "   ORIGIN_IP=<the Fly IPv4> CF_ZONE_DOMAIN=\"\$CF_ZONE_DOMAIN\" ./scripts/03-verify.sh"
echo
echo "ℹ️  This script only printed the commands — nothing was created or billed."
