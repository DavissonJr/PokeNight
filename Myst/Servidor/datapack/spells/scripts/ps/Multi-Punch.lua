function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Multi-Punch")

return true
end