function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Low Kick")

return true
end