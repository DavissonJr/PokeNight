function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Punch Darkness")

return true
end