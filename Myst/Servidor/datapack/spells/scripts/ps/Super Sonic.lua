function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Super Sonic")

return true
end