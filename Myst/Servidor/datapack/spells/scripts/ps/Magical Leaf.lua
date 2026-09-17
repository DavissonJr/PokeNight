function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Magical Leaf")

return true
end