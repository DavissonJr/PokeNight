function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Calm Mind")

return true
end