function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Petal Dance")

return true
end