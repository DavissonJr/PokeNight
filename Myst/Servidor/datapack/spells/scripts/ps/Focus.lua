function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Focus")

return true
end