function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Triple Kick Lee")

return true
end