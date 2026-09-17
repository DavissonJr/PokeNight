function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Blaze Kick")

return true
end