function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Petal Tornado")

return true
end