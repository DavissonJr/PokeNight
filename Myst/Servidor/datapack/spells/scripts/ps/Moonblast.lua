function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Moonblast")

return true
end