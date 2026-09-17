function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Tri Flames")

return true
end