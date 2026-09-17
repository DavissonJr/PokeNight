function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Sonicboom")

return true
end