function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sand Tomb")

return true
end