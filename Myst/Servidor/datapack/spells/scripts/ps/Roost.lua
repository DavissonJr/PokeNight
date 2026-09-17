function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Roost")

return true
end