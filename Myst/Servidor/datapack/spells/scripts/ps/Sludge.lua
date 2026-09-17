function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sludge")

return true
end