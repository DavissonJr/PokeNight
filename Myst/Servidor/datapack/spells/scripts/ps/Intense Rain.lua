function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Intense Rain")

return true
end