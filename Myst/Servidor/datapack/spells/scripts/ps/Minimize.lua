function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Minimize")

return true
end