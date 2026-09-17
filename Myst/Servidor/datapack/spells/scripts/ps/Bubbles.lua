function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bubbles")

return true
end