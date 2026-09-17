function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Fang")

return true
end