FROM openresty/openresty:alpine-fat

RUN apk add \
      --no-cache --virtual runtime \
      bash \
      coreutils \
      curl \
      diffutils \
      grep \
      openssl \
      sed && \
      # Even though we install full pkill (via the procps package, which we do for
      # "-U" support in our tests), the /usr/bin version that symlinks BusyBox's
      # more limited pkill version takes precedence. So manually remove this
      # BusyBox symlink to the full pkill version is used.
      if [ -L /usr/bin/pkill ]; then rm /usr/bin/pkill; fi

RUN luarocks install lua-resty-http \
    && luarocks install lua-resty-auto-ssl 0.11.0 \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && mkdir -p /certificates \
    && openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
       -subj '/CN=sni-support-required-for-valid-ssl' \
       -keyout /certificates/resty-auto-ssl-fallback.key \
       -out /certificates/resty-auto-ssl-fallback.crt \
    && mkdir -p /usr/local/openresty/nginx/conf.d \
    && ln -s /usr/local/openresty/nginx /etc \
    && ln -s /usr/local/openresty/nginx/logs/ /var/log/nginx

# customized nginx.conf based on nginx's image default
# and lua-resty-auto-ssl example:
#
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY auto-ssl.conf /usr/local/openresty/nginx/conf/auto-ssl.conf

# vhost default as defined in the nginx docker container
#
COPY nginx.vh.default.conf /usr/local/openresty/nginx/conf.d/default.conf

RUN chown -R nginx:nginx /certificates

ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]
