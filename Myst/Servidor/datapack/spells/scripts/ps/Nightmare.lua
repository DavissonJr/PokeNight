function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Nightmare")

return true
end