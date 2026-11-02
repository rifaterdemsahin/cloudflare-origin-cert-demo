#!/usr/bin/env bash
# Verifies that the origin server presents the Cloudflare Origin CA certificate
# and that the chain/issuer looks correct.
set -euo pipefail

OUT_DIR="${OUT_DIR:-./out}"
DOMAIN="${CF_ZONE_DOMAIN:?Set CF_ZONE_DOMAIN}"
ORIGIN_IP="${ORIGIN_IP:?Set ORIGIN_IP to the origin server public IP}"

echo "🔍 Checking locally-issued cert metadata..."
if [ -f "$OUT_DIR/origin-cert-metadata.json" ]; then
  jq '{id, expires_on, hostnames}' "$OUT_DIR/origin-cert-metadata.json"
fi

echo
echo "🔍 Checking what the origin server actually presents over TLS..."
echo | openssl s_client -connect "$ORIGIN_IP:443" -servername "$DOMAIN" 2>/dev/null \
  | openssl x509 -noout -issuer -subject -dates

echo
echo "🔍 End-to-end curl check (bypassing DNS, hitting origin IP directly)..."
curl -sv --resolve "$DOMAIN:443:$ORIGIN_IP" "https://$DOMAIN/" -o /dev/null 2>&1 \
  | grep -E "subject:|issuer:|SSL certificate verify (ok|failed)" || true

echo
echo "✅ Expect issuer to contain: CloudFlare Origin SSL Certificate Authority"
