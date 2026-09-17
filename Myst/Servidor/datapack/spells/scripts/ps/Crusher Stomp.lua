function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Crusher Stomp")

return true
end