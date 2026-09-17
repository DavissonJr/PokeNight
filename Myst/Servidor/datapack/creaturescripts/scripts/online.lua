-- Criado por Thalles Vitor --
-- Mudar o Estado da Bolinha --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 121 then
		local param = buffer:explode("@")
		local status = tostring(param[1])
		local dir = "data/images/game/status/" .. status .. ".png"

		doPlayerSetStatus(cid, dir)
	end
	return true
end