function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rock Drill")

return true
end