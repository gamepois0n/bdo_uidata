
function FromWeb_WebPageError(url, statusCode)
	if statusCode ~= 200 then
		_PA_LOG("LUA", "url : "..tostring(url))
	end
end

registerEvent("FromWeb_WebPageError",							"FromWeb_WebPageError")