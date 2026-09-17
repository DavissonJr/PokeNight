function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Electro Field")

return true
end