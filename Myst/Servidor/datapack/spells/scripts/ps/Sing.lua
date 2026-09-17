function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sing")

return true
end