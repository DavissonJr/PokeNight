function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Blizzard")

return true
end