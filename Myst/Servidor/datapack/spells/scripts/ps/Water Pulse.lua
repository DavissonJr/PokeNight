function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Water Pulse")

return true
end