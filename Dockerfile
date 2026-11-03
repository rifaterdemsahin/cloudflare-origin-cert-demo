FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY rationale.html /usr/share/nginx/html/rationale.html
COPY create-certificate.html /usr/share/nginx/html/create-certificate.html
COPY images /usr/share/nginx/html/images
EXPOSE 80
