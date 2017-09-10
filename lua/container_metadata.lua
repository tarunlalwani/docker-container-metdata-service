local cjson = require("cjson")
local jp = require("jsonpath")

local cid = ngx.var.cid
local command = ngx.var.command
local subcommand = ngx.var.subcommand
ngx.log(ngx.ERR, "cid="..cid.. ", command=".. command .. ", subcommand=" .. subcommand)
local filters = cjson.encode({id = {cid}})
local res = ngx.location.capture("/containers/json", {args = {filters = filters}})
if not res then
   ngx.status = 404
   return ngx.exit(ngx.HTTP_NOT_FOUND)
else
  local data = cjson.decode(res.body);
  ngx.header.content_type = "application/json"
  local json_filter = "$..*"
  if not ngx.var.arg_json_filter == "" then
     json_filter = ngx.var.arg_json_filter
  elseif command == "labels" then
     json_filter = "$..Labels"
     if subcommand ~= '' then
        json_filter = "$..['Labels']['".. subcommand  .. "']"
     end
  end
  
  ngx.log(ngx.ERR, "Using json_filter:" .. json_filter)
  local result = jp.value(data, json_filter)
  if type(result) == "string" then
     ngx.say(result)
  else
     ngx.say(cjson.encode(result))
  end
end
   
-- ngx.say(cjson.encode(jp.value(data, "$..['Labels']['com.docker.compose.container-number']")))


