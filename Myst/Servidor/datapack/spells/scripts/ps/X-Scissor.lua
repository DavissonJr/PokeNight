function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "X-Scissor")

return true
end