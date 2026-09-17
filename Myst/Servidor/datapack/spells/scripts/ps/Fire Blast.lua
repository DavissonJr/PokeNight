function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fire Blast")

return true
end