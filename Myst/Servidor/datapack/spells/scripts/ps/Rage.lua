function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rage")

return true
end