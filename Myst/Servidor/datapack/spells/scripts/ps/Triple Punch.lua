function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Triple Punch")

return true
end