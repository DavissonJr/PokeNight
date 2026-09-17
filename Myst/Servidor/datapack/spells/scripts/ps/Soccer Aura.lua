function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Soccer Aura")

return true
end