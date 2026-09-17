function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sleep Powder")

return true
end