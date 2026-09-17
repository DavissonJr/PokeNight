function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Power Wave")

return true
end