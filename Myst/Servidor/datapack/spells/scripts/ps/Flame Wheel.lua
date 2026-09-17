function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Flame Wheel")

return true
end