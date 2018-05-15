
### 一、nginx 配置

1. `nginx error.log` 的日志输出级别改为 `notice`

`error_log  logs/error.log  notice;`
2. 增加三个 `location`

    ```
    location ~ ^/api/(.*) {
        content_by_lua_file lua/$1.lua;
    }

    location /data {
        alias /home/majun/data;
        internal;
    }

    location /apidoc {
        alias /home/majun/git/openresty/file_server/doc;
    }
    ```
3. 将 `upload.lua` 和 `download.lua` 脚本放置于 `~/openresty/nginx/lua/` 路径下

4. 配置信息在 config.lua 中

5. 访问 ~/apidoc/index.html 将会显示接口文档
