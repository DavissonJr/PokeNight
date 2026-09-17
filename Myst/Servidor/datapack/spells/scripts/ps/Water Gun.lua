function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Water Gun")

return true
end