function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Super Vines")

return true
end