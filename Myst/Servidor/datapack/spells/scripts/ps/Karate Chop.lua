function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Karate Chop")

return true
end