function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rolling Kick")

return true
end