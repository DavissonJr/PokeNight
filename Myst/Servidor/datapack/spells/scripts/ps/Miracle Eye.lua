function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Miracle Eye")

return true
end