package.path = '/usr/local/openresty/lualib/resty/?.lua;/usr/local/openresty/nginx/lua/?.lua'
package.cpath = '/usr/local/openresty/lualib/?.so;'

local upload = require "upload"
local cjson = require "cjson"
local config = require "config"

local chunk_size = 4096
local form = upload:new(chunk_size)
local file
local filelen=0
form:set_timeout(0) -- 1 sec
local filename


--local osfilepath = "/home/majun/data/"


local response = {}


function random_filename()
    local t = ngx.req.start_time()
    local name = ngx.md5(t)
    response["fid"] = name
    response["upload_time"] = t
    return name
end


function file_path(random_filename)
    local path1 = string.sub(random_filename, 1, 1)
    local path2 = string.sub(random_filename, 2, 3)
    local p = config.UPLOAD_PATH..path1.."/"..path2.."/"
    return p
end


function get_actual_filename(res)
    local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    if filename then 
        return filename[2]
    end
end


local i=0
while true do
    local typ, res, err = form:read()
    if not typ then

        response["fid"] = "None"
        response["upload_status"] = err
        ngx.log(ngx.NOTICE,"[lua_file_server] ERR:", err)
        return
    end
    if typ == "header" then
        if res[1] ~= "Content-Type" then
            local actual_name = get_actual_filename(res[2])
            ngx.log(ngx.NOTICE,"[lua_file_server] upoload filename:", actual_name)
            response["filename"] = actual_name
            local random_filename = random_filename()
            if random_filename then
                i=i+1
                local file_path = file_path(random_filename)
                os.execute("mkdir -p "..file_path)
                local filepath = file_path .. random_filename
                file , error = io.open(filepath,"w+")
                if not file then

                    response["fid"] = "None"
                    response["upload_status"] = err
                    --ngx.say(cjson.encode(response))
                    --ngx.say("failed to open file ")
                    ngx.log(ngx.NOTICE,"[lua_file_server] upoload, err:", err)

                    return
                end
            else
            end
        end
    elseif typ == "body" then
        if file then
            local filelen= filelen + tonumber(string.len(res))    
            file:write(res)
        else
        end
    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil

            response["upload_status"] = "upload_success"
            --ngx.say(cjson.encode(response))
            --ngx.say("file upload success")
            ngx.log(ngx.NOTICE,"[lua_file_server] upoload, success")
        end
    elseif typ == "eof" then
        break
    else
    end
end
if i==0 then

    response["fid"] = "None"
    response["filename"] = "None"
    response["upload_status"] = "please upload at least one file!"
    --ngx.say(cjson.encode(response))
    --ngx.say("please upload at least one file!")
    ngx.log(ngx.NOTICE,"[lua_file_server] please upload at least one file!")
    return
end

ngx.say(cjson.encode(response))