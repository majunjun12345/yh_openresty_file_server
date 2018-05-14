--[[
@api {get} /api/download 下载文件, 返回文件数据流
@apiName download
@apiGroup api
@apiParam {string} fid 文件fid.
--]]


package.path = '/usr/local/openresty/nginx/lua/?.lua'


local config = require "config"
local args= ngx.req.get_uri_args()


function file_path()
    local fid = args["fid"]
    if(string.len(fid) >= 16 and type(fid) == "string")
    then
        local path = string.sub(fid, 1, 1) .. "/" .. string.sub(fid, 2, 3) .. "/" .. fid
        local location_path = config.DOWNLOAD_PATH .. path
        return location_path
    else
        ngx.log(ngx.NOTICE,"[lua_file_server] PARA ERR")
    end
end


function redirect()
    location_path = file_path()
    if location_path then 
        ngx.exec(location_path)
        return
    end
end


redirect()