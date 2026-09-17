function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Gas")

return true
end