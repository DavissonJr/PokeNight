function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Reflect")

return true
end