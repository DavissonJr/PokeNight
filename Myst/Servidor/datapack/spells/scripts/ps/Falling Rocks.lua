function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Falling Rocks")

return true
end