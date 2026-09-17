function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Furia do Dragao")

return true
end