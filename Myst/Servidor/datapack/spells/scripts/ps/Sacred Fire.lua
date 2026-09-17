function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sacred Fire")

return true
end