function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Fist Machine")

return true
end