local args, err = ngx.req.get_uri_args()

if err == "truncated" then
    ngx.say("para err")
end


function file_path()
    fid = args["fid"]
    path = string.sub(fid, 1, 1) .. "/" .. string.sub(fid, 2, 3) .. "/" .. fid
    location_path = "/data" .. "/" .. path
    return location_path
end


location_path = file_path()
if location_path then 
    ngx.exec(location_path)
    return
end