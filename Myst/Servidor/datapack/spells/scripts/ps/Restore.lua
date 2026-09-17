function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Restore")

return true
end