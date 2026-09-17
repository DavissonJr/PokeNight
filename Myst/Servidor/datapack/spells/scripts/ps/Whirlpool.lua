function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Whirlpool")

return true
end