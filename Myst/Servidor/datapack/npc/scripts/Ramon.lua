local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function msgcontains(txt, str)
	return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

local talkState = {}
local opcao1 = "";
local opcao2 = "";
local opcaoEscolhida = "";
local tchau = false

function creatureSayCallback(cid, type, msg)
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local objetos = getListOfObjectsByDifficulty(cid)
	
	if not (getDistanceToCreature(cid) <= 3) then
		return true
	end
	
	if getPlayerStorageValue(cid, objetos.storages.endQuest) >= 1 then
		selfSay("Você já completou minha task por hoje.", cid)
		talkState[talkUser] = 0
		tchau = true
		focus = 0
		return true	
	end   
	
	if (msgcontains(msg, opcao1) or msgcontains(msg, opcao2)) and talkState[talkUser] == 1 then
		opcaoEscolhida = msg;
		setPokemonEscolhido(cid, opcaoEscolhida)
		selfSay("Ok, volte quando conseguir capturar "..opcaoEscolhida.."!", cid)
		setPlayerStorageValue(cid, objetos.storages.catch, 1)
		talkState[talkUser] = 2;
	end
		
	if msgcontains(msg, "yes") and talkState[talkUser] ~= 2 and talkState[talkUser] ~= 3 then
		setTaskDailyCatch(cid, objetos) 
		opcao1 = getPokemonForDailyCatch(cid, "opcao_poke1");
		opcao2 = getPokemonForDailyCatch(cid, "opcao_poke2");
		selfSay("Catch de nível "..getDificultyForDailyCatch(cid)..", deseja capturar "..opcao1.." ou "..opcao2.."?", cid)
		talkState[talkUser] = 1;
		
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 2 then
	   selfSay("Você conseguiu capturar "..getPokemonForDailyCatch(cid, "poke_escolhido").."?", cid)
	   talkState[talkUser] = 3;
	   
	elseif msgcontains(msg, "yes") and talkState[talkUser] == 3 then
		if (getPlayerStorageValue(cid, objetos.storages.catchSucess) >= 1) then
			selfSay("Parabéns, pegue sua recompensa.", cid)
			doPlayerAddExp(cid, objetos.experiencia);
			doPlayerAddItem(cid, objetos.recompensa.item, objetos.recompensa.quantidade);
			doSendAnimatedText(getThingPos(cid), objetos.experiencia, 173)
			doSendMagicEffect(getThingPos(cid), 173) 
			setPlayerStorageValue(cid, objetos.storages.endQuest, 1)
			dificilPokesParaDailyCatch(cid, getDificultyForDailyCatch(cid))
			addOpcaoForChoosePokemonDailyCatch(cid, objetos.pokes)
		else
			selfSay("Você ainda não capturou ".. opcaoEscolhida ..".", cid)
		end
		talkState[talkUser] = 0
		tchau = true
		focus = 0
		return true	
	end
	if msgcontains(msg, "no") then
		selfSay("Então volte mais tarde...", cid)
		tchau = true
		focus = 0
		return true	
	end
	
	if tchau then
		tchau = false
		selfSay('Até mais.')
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())