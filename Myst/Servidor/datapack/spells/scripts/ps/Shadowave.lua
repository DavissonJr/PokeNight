function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Shadowave")

return true
end