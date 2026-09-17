function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sucker Punch")

return true
end