FROM alpine as build
RUN apk --no-cache add nginx
COPY . /var/www/html
RUN cd /var/www/html \
 && find . -type f -a \( \
      -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.tff' -o -name '*.map' -o -name '*.woff' -o -name '*.woff2' \
      -o -name '*.json' -o -name '*.xml' -o -name '*.svg' -o -name '*.txt' \) \
      -exec gzip -f -9 -k {} \+

FROM nginxinc/nginx-unprivileged:stable-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /var/www/html /var/www/html
