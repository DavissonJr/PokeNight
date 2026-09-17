function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Damange Stom")

return true
end