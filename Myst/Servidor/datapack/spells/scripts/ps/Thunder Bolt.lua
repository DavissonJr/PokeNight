function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Thunder Bolt")

return true
end