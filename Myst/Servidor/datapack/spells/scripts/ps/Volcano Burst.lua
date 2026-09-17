function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Volcano Burst")

return true
end