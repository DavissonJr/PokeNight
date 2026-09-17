function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Meteor Splash")

return true
end