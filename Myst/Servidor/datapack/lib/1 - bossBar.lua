-- Criado por Thalles Vitor --
-- Barra de Boss --
BOSS_OPCODE = 20 -- enviar barra de boss
BOSSES = {"Regice", "Registeel", "Regirock", "Furious Charizard", "Primal Kyogre", "Cresselia", "Regigigas", "Lugia", "Giratina", "Rayquaza",
"Entei", "Suicune", "Raikou", "Celebi", "Shiny Celebi", "Latios", "Latias", "Shaymin", "Hoopa", "Mew", "Mewtwo", "Palkia", 
"Articuno", "Zapdos", "Moltres", "Kyogre", "Guardian Magmar", "Dialga", "Charizard Halloween", "Giant Gengar", "Marowak Halloween", "Jirachi", "Groudon",
"Darkrai", "Darkrai Nightmare", "Primal Dialga", "Zekrom", "Kyurem", "White Kyurem", "Black Kyurem", "Reshiram"}

function getDistanceToMonster(cid, target)
	if not isPlayer(cid) then
		return false
	end

	local pos1 = getCreaturePosition(cid).x - getCreaturePosition(target).x
	local pos2 = getCreaturePosition(cid).y - getCreaturePosition(target).y
	local pos3 = math.max(pos1, pos2)
	if pos3 > 3 then
		return true
	end

	return false
end

function onSendBossBarLife(cid, target)
	if isPlayer(cid) and not isCreature(target) then
		local name = ""
		local percent = 0
		doSendPlayerExtendedOpcode(cid, BOSS_OPCODE, name.."@"..percent.."@".."hide".."@".."0".."@".."0".."@")
		return true
	end

	if getDistanceToMonster(cid, target) then
		local name = ""
		local percent = 0
		doSendPlayerExtendedOpcode(cid, BOSS_OPCODE, name.."@"..percent.."@".."hide".."@".."0".."@".."0".."@")
		return true
	end

	if isPlayer(cid) and isCreature(target) and getCreatureHealth(target) <= 0 then
		local name = ""
		local percent = 0
		doSendPlayerExtendedOpcode(cid, BOSS_OPCODE, name.."@"..percent.."@".."hide".."@".."0".."@".."0".."@")
		return true
	end

	if isPlayer(cid) and not isSummon(target) and isMonster(target) and isInArray(BOSSES, getCreatureName(target)) then
		local name = getCreatureName(target)
		local percent = math.floor(getCreatureHealth(target) / getCreatureMaxHealth(target) * 100)
		doSendPlayerExtendedOpcode(cid, BOSS_OPCODE, name.."@"..percent.."@".."".."@"..getMonsterInfo(name).lookType.."@"..string.format("%1.0f", getCreatureHealth(target)).."@")
		
		addEvent(function()
			onSendBossBarLife(cid, target)
		end, 1000)
	end
	return true
end