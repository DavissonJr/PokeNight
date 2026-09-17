function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rain Dance")

return true
end