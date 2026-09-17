function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Selfheal")

return true
end