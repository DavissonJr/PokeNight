function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Aura Sphere")

return true
end