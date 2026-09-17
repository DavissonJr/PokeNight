function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Eternal Punch")

return true
end