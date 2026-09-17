function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Revenge")

return true
end