function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Camuflage")

return true
end