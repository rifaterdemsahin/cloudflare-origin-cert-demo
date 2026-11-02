#!/bin/sh
# 🔐 Writes the Origin CA cert + key from Fly secrets (base64 env vars) to disk,
# then hands off to nginx, which terminates TLS with that exact cert.
set -eu

mkdir -p /etc/ssl/cloudflare

: "${ORIGIN_CERT_B64:?Set ORIGIN_CERT_B64 as a Fly secret (base64 of origin.pem)}"
: "${ORIGIN_KEY_B64:?Set ORIGIN_KEY_B64 as a Fly secret (base64 of origin.key)}"

echo "$ORIGIN_CERT_B64" | base64 -d > /etc/ssl/cloudflare/origin.pem
echo "$ORIGIN_KEY_B64" | base64 -d > /etc/ssl/cloudflare/origin.key
chmod 600 /etc/ssl/cloudflare/origin.key

echo "🔐 Origin cert installed at /etc/ssl/cloudflare/origin.pem"
exec nginx -g 'daemon off;'
