function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Octazooka")

return true
end