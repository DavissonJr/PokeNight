function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Dazzling Gleam")

return true
end