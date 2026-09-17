function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Magma Storm")

return true
end