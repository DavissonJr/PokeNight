function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Multi-Kick")

return true
end