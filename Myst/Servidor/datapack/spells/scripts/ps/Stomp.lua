function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Stomp")

return true
end