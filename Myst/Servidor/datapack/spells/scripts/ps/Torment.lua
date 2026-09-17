function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Torment")

return true
end