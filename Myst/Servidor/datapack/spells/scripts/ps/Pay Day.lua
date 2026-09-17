function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Pay Day")

return true
end