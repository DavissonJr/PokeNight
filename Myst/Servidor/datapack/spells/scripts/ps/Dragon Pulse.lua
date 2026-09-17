function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Dragon Pulse")

return true
end