function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Gust")

return true
end