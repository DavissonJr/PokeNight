function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Triple Kick")

return true
end