function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fighter Spirit")

return true
end