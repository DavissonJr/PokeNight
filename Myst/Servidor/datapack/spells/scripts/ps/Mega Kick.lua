function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Mega Kick")

return true
end