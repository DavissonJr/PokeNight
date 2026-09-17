function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Razor Leaf")

return true
end