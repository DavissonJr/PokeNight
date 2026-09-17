function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Waterball")

return true
end