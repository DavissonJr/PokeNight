function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Peck")

return true
end