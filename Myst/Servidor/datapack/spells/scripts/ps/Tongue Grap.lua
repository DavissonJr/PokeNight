function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Tongue Grap")

return true
end