function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Feather Dance")

return true
end