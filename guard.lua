local jwt = require "resty.jwt"
local jwt_token = ngx.var.arg_jwt
if jwt_token then
    ngx.header['Set-Cookie'] = "jwt=" .. jwt_token
else
    jwt_token = ngx.var.cookie_jwt
end

local jwt_obj = jwt:verify("lua-resty-jwt", jwt_token)

if not jwt_obj["verified"] then
    local site = ngx.var.scheme .. "://" .. ngx.var.http_host;
    local args = ngx.req.get_uri_args();

    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(jwt_obj.reason);
    ngx.exit(ngx.HTTP_OK)

    -- or you can redirect to your website to get a new jwt token
    -- then redirect back
    -- return ngx.redirect("http://your-site-host/get_jwt")
end