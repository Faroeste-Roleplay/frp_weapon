--[[
	Bridge for frp_core — server side. Points API/AbilityService straight at
	frp_core's Proxy interfaces, same as before the bridge split existed.
]]

API = Proxy.getInterface("API")
AbilityService = Proxy.getInterface("abilities")
