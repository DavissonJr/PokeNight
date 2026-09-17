function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Synthesis")

return true
end