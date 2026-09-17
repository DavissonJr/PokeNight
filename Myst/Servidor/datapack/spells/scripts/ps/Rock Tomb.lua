function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rock Tomb")

return true
end