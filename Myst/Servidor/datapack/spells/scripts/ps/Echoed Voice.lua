function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Echoed Voice")

return true
end