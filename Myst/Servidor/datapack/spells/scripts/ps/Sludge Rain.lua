function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sludge Rain")

return true
end