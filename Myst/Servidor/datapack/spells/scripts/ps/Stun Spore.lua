function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Stun Spore")

return true
end