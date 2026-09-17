function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Dizzy Punch")

return true
end