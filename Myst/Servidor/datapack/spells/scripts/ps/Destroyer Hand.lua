function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Destroyer Hand")

return true
end