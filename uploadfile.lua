package.path = '/usr/local/openresty/lualib/resty/?.lua;/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;'
package.cpath = '/usr/local/openresty/lualib/?.so;/usr/local/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so;'

local upload = require "upload"
local cjson = require "cjson"

local chunk_size = 4096
local form = upload:new(chunk_size)
local file
local filelen=0
form:set_timeout(0) -- 1 sec
local filename


local osfilepath = "/home/majun/data/"


local response = {}


function random_filename()
    t = ngx.req.start_time()
    name = ngx.md5(t)
    response["fid"] = name
    response["upload_time"] = t
    return name
end


function file_path(random_filename)
    path1 = string.sub(random_filename, 1, 1)
    path2 = string.sub(random_filename, 2, 3)
    p = osfilepath..path1.."/"..path2.."/"
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
        ngx.say(cjson.encode(response))
        --ngx.say("failed to read: ", err)
        
        return
    end
    if typ == "header" then
        if res[1] ~= "Content-Type" then
            actual_name = get_actual_filename(res[2])
            response["filename"] = actual_name
            random_filename = random_filename()
            if random_filename then
                i=i+1
                file_path = file_path(random_filename)
                os.execute("mkdir -p "..file_path)
                filepath = file_path .. random_filename
                file , error = io.open(filepath,"w+")
                if not file then

                    response["fid"] = "None"
                    response["upload_status"] = err
                    --ngx.say(cjson.encode(response))
                    --ngx.say("failed to open file ")
                    
                    return
                end
            else
            end
        end
    elseif typ == "body" then
        if file then
            filelen= filelen + tonumber(string.len(res))    
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

        end
    elseif typ == "eof" then
        break
    else
    end
end
if i==0 then

    response["fid"] = "None"
    response["upload_status"] = "please upload at least one file!"
    --ngx.say(cjson.encode(response))
    --ngx.say("please upload at least one file!")

    return
end

ngx.say(cjson.encode(response))