function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Burn Skin")

return true
end