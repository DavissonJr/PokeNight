function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Dream Eater")

return true
end