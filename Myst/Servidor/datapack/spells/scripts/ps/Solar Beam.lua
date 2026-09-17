function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Solar Beam")

return true
end