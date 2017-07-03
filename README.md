# openresty_autossl

Another Dockerfile/repo that aims to combine the awesome [lua-resty-auto-ssl](https://github.com/GUI/lua-resty-auto-ssl) tooling
with [OpenResty](https://github.com/openresty/docker-openresty).

By default some common practices of the official nginx image have been adopted.

[Automated Build on Docker Hub](https://hub.docker.com/r/rmoriz/openresty_autossl/)


# Usage

TODO, sorry


```shell
docker pull rmoriz/openresty_autossl
docker run -d -p 80:80 -p 443:443 rmoriz/openresty_autossl
```

# Thanks!

- https://github.com/msumpter/docker-lua-resty-auto-ssl
- https://github.com/TheRightPlace/docker-lua-resty-auto-ssl

