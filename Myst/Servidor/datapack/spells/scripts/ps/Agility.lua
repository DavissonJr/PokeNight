function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Agility")

return true
end