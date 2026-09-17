function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Acid Armor")

return true
end