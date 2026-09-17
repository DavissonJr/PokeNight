function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Divine Punishment")

return true
end