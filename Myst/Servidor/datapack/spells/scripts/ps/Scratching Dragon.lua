function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Scratching Dragon")

return true
end