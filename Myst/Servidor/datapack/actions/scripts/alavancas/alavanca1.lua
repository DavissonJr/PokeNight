-- Criado por Thalles Vitor --
-- Alavanca 1 --

local pos = {x=2089, y=1013, z=8}
function onUse(cid, item)
	doTeleportThing(cid, pos)
	return true
end