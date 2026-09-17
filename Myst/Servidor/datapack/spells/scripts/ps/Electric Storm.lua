function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Electric Storm")

return true
end