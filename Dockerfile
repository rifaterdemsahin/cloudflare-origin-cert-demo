FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY rationale.html /usr/share/nginx/html/rationale.html
EXPOSE 80
