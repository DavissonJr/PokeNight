function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Jab")

return true
end