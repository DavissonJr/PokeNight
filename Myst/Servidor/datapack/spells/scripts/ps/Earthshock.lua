function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Earthshock")

return true
end