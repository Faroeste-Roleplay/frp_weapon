--[[
	Bridge for frp_core — client side. Points cAPI/Abilities straight at
	frp_core's Proxy interfaces; frp_core itself fires FRP:onCharacterLoaded
	/ FRP:onCharacterLogout, so no extra wiring is needed here.
]]

cAPI = Proxy.getInterface("API")
Abilities = Proxy.getInterface("abilities")
