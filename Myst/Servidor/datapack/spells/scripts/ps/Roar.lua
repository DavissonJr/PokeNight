function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Roar")

return true
end