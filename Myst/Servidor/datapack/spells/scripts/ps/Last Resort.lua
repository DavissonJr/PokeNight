function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Last Resort")

return true
end