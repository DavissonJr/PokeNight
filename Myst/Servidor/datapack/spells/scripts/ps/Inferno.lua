function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Inferno")

return true
end