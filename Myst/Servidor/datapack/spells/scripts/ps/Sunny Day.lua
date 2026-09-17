function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sunny Day")

return true
end