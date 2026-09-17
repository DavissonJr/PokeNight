function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Mortal Gas")

return true
end