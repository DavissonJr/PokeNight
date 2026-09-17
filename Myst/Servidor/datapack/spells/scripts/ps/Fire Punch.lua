function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fire Punch")

return true
end