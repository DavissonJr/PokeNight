function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fissure")

return true
end