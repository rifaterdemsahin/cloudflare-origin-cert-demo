# 🖥️ "Origin server" image for the Fly.io worked example.
# Decodes the Origin CA cert/key from Fly secrets at boot, then runs nginx
# terminating TLS itself — exactly like a VM/VPS origin behind Cloudflare.
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
