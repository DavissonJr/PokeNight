function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Magic Coat")

return true
end