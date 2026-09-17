function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Vine Whip")

return true
end