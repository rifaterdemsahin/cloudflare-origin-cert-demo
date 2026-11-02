#!/usr/bin/env bash
# Generates a private key + CSR for a Cloudflare Origin CA certificate request.
# The private key stays local and is never sent to Cloudflare.
set -euo pipefail

OUT_DIR="${OUT_DIR:-./out}"
DOMAIN="${CF_ZONE_DOMAIN:?Set CF_ZONE_DOMAIN, e.g. export CF_ZONE_DOMAIN=example.com}"

mkdir -p "$OUT_DIR"

echo "🔑 Generating 2048-bit RSA private key -> $OUT_DIR/origin.key"
openssl genrsa -out "$OUT_DIR/origin.key" 2048

echo "📝 Generating CSR for CN=$DOMAIN -> $OUT_DIR/origin.csr"
openssl req -new \
  -key "$OUT_DIR/origin.key" \
  -out "$OUT_DIR/origin.csr" \
  -subj "/CN=$DOMAIN"

chmod 600 "$OUT_DIR/origin.key"

echo "✅ Done:"
echo "   $OUT_DIR/origin.key  (keep secret, never commit)"
echo "   $OUT_DIR/origin.csr  (safe to share with Cloudflare)"
