function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sun Blast")

return true
end