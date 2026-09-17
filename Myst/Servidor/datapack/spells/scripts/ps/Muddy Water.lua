function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Muddy Water")

return true
end