function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Surf")

return true
end