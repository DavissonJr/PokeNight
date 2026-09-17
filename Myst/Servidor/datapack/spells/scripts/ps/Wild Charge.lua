function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Wild Charge")

return true
end