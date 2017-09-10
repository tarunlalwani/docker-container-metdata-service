FROM openresty/openresty:alpine-fat
RUN apk update && apk add git socat && /usr/local/openresty/luajit/bin/luarocks install jsonpath


