function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bug Fighter")

return true
end