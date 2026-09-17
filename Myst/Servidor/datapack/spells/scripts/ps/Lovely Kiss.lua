function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Lovely Kiss")

return true
end