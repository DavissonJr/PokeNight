function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Powder")

return true
end