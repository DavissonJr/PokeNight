function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Thunder Shock")

return true
end