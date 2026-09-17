function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Scary Face")

return true
end