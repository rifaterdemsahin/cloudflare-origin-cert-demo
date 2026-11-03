#!/usr/bin/env bash
# Sends the CSR to Cloudflare's Origin CA API and saves the signed certificate.
# Docs: https://developers.cloudflare.com/api/resources/origin_ca_certificates/
set -euo pipefail

OUT_DIR="${OUT_DIR:-./out}"

# Origin CA Service Key (X-Auth-User-Service-Key) was removed on Sept 30, 2026.
# Use an API Token with Zone > SSL and Certificates > Edit permissions.
if [ -z "${CF_API_TOKEN:-}" ]; then
  if [ -n "${CF_ORIGIN_CA_KEY:-}" ]; then
    echo "❌ CF_ORIGIN_CA_KEY (Service Key) was deprecated and removed on September 30, 2026." >&2
    echo "   Please create an API Token with 'Zone > SSL and Certificates > Edit' and export CF_API_TOKEN." >&2
    exit 1
  fi
  echo "❌ Error: CF_API_TOKEN is required." >&2
  echo "   Create an API Token (dash.cloudflare.com -> My Profile -> API Tokens)" >&2
  echo "   Permissions: Zone > SSL and Certificates > Edit" >&2
  echo "   Then: export CF_API_TOKEN=\"your-api-token\"" >&2
  exit 1
fi

HOSTNAMES="${CF_HOSTNAMES:?Set CF_HOSTNAMES, e.g. export CF_HOSTNAMES=example.com,*.example.com}"
VALIDITY_DAYS="${CF_VALIDITY_DAYS:-5475}"   # 5475 = 15 years (max). Other allowed: 7,30,90,365,730,1095
CSR_FILE="$OUT_DIR/origin.csr"

[ -f "$CSR_FILE" ] || { echo "❌ $CSR_FILE not found. Run 01-generate-csr.sh first." >&2; exit 1; }

# Build a JSON hostnames array from the comma-separated CF_HOSTNAMES
hostnames_json=$(printf '%s' "$HOSTNAMES" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | jq -R . | jq -s .)
csr_json=$(jq -Rs . < "$CSR_FILE")

payload=$(jq -n \
  --argjson hostnames "$hostnames_json" \
  --argjson validity "$VALIDITY_DAYS" \
  --argjson csr "$csr_json" \
  '{hostnames: $hostnames, requested_validity: $validity, request_type: "origin-rsa", csr: $csr}')

echo "📡 Requesting Origin CA certificate for: $HOSTNAMES"

response=$(curl -s https://api.cloudflare.com/client/v4/certificates \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$payload")

success=$(printf '%s' "$response" | jq -r '.success')

if [ "$success" != "true" ]; then
  echo "❌ Cloudflare API error:" >&2
  printf '%s\n' "$response" | jq '.errors' >&2
  exit 1
fi

printf '%s' "$response" | jq -r '.result.certificate' > "$OUT_DIR/origin.pem"
printf '%s' "$response" | jq '.result' > "$OUT_DIR/origin-cert-metadata.json"

echo "✅ Signed certificate saved -> $OUT_DIR/origin.pem"
echo "ℹ️  Metadata (id, expires_on, hostnames) -> $OUT_DIR/origin-cert-metadata.json"
echo
echo "Next: install $OUT_DIR/origin.pem + $OUT_DIR/origin.key on your origin server,"
echo "then run ./scripts/03-verify.sh"
