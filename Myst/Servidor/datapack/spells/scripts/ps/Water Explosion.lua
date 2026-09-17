function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Water Explosion")

return true
end