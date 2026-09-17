function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Iron Defense")

return true
end