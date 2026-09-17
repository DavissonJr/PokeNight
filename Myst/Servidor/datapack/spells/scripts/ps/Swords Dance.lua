function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Swords Dance")

return true
end