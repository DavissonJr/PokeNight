function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Sting")

return true
end