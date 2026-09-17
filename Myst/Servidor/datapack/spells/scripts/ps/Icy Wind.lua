function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Icy Wind")

return true
end