function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Tongue Hook")

return true
end