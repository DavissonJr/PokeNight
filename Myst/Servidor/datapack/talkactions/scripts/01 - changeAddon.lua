-- [
    -- Cosmic Programmer
    --~~ Thalles Vitor ~~--
    --~~ Troca ou Revenda é proibido ~~--
    --~~ Pedido: Script de Addon System (LUA - 100$) ~~--
--]

function onSay(cid, words, param)
	if tonumber(param) then
		local pokebola = getPlayerSlotItem(cid, 8)
		if pokebola.uid <= 0 then
			doPlayerSendTextMessage(cid, 22, "É necessário um pokémon no slot")
			return true
		end

		if #getCreatureSummons(cid) <= 0 then
			doPlayerSendTextMessage(cid, 22, "Para usar este comando é necessário um pokémon!")
			return true
		end

		if tonumber(param) == 0 then
			local atributo = tonumber(getItemAttribute(pokebola.uid, "lastAddon")) or 0
			if atributo > 0 then
				doItemEraseAttribute(pokebola.uid, "lastAddon")
				doRemoveCondition(getCreatureSummons(cid)[1], CONDITION_OUTFIT)
				doPlayerSendTextMessage(cid, 25, "Você removeu o addon do seu pokémon.")
			end

			return true
		end

		local pk = getCreatureSummons(cid)[1]
		local atributo = getItemAttribute(pokebola.uid, "addon"..tonumber(param))
		if atributo ~= nil then
			doItemSetAttribute(pokebola.uid, "lastAddon", atributo)
			doItemSetAttribute(pokebola.uid, "lastAddonName", getItemAttribute(pokebola.uid, "addonName"..tonumber(param)))
			doItemSetAttribute(pokebola.uid, "addonFly", getItemAttribute(pokebola.uid, "addonFly"..tonumber(param)))
			doItemSetAttribute(pokebola.uid, "addonSurf", getItemAttribute(pokebola.uid, "addonSurf"..tonumber(param)))
			doItemSetAttribute(pokebola.uid, "addonRide", getItemAttribute(pokebola.uid, "addonRide"..tonumber(param)))
			doSetCreatureOutfit(pk, {lookType = atributo}, -1)
			doPlayerSendTextMessage(cid, 22, "Você trocou a addon do seu pokémon para: " .. getItemAttribute(pokebola.uid, "addonName"..tonumber(param)) .. ".")
		end
	else
		doPlayerSendTextMessage(cid, 22, "Digite uma numeração correta, lembrando que a quantidade maxima de addons é de 1 a 3.")
		return true
	end
	return true
end