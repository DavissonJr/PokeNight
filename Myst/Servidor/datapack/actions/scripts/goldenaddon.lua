function onUse(cid, item, fromPosition, itemEx, toPosition)
local addons = {
-- Shiny Mamoswine
[27990] = {pokemon= "Shiny Mamoswine", looktype = 3029, nome = "Fang Frozen Addon", fly =  0, ride = 0, surf = 0},
-- Mamoswine
[27993] = {pokemon= "Mamoswine", looktype = 3021, nome = "Gold Helmet Addon", fly =  0, ride = 0, surf = 0},
[27996] = {pokemon= "Mamoswine", looktype = 3019, nome = "Gold Ties Addon", fly =  0, ride = 0, surf = 0},
-- Shiny Gardevoir
[27995] = {pokemon= "Shiny Gardevoir", looktype = 3022, nome = "Housekeeper Addon", fly =  0, ride = 0, surf = 0},
[28003] = {pokemon= "Shiny Gardevoir", looktype = 3023, nome = "Purple Princess Addon", fly =  0, ride = 0, surf = 0},
[28001] = {pokemon= "Shiny Gardevoir", looktype = 3028, nome = "Red Magic Addon", fly =  0, ride = 0, surf = 0},
[27988] = {pokemon= "Shiny Gardevoir", looktype = 2286, nome = "Carpted Addon", fly =  0, ride = 0, surf = 0},

-- Shiny Dragonite
[28004] = {pokemon= "Shiny Dragonite", looktype = 3024, nome = "Dragon Green Addon", fly =  3027, ride = 0, surf = 0},
[28000] = {pokemon= "Shiny Dragonite", looktype = 3026, nome = "Dragon Purple Addon", fly =  3025, ride = 0, surf = 0},

}
 
if #getCreatureSummons(cid) > 0 then
if getPlayerLanguage(cid) == 0 then
doPlayerTextMessage(cid, 22, "Por favor volte seu pokémon.")
end
if getPlayerLanguage(cid) == 1 then
doPlayerTextMessage(cid, 22, "Por favor, vuelve su pokémon.")
end	
if getPlayerLanguage(cid) == 2 then
doPlayerTextMessage(cid, 22, "Please back your pokémon.")
end
return false
end     
local addon = addons[item.itemid].looktype
local fly = addons[item.itemid].fly
local ride = addons[item.itemid].ride
local surf = addons[item.itemid].surf
local addonlook = addons[item.itemid].nome
 
local pb = getPlayerSlotItem(cid, 8).uid
local pk = addons[item.itemid].pokemon
 
if getItemAttribute(pb,"poke") ~= pk then
if getPlayerLanguage(cid) == 0 then
doPlayerSendCancel(cid, "Desculpa, você não pode usar esse addon nesse pokémon.")
end

if getItemAttribute(pb,"addons") < 1 then
doPlayerSendTextMessage(cid, 27, "Congratulations! Now your pokemon will use the addon.")
doSetItemAttribute(pb,"addons",numero)
return true
end

if getPlayerLanguage(cid) == 1 then
doPlayerSendCancel(cid ,"Lo sentimos, no se puede utilizar este addon en esse pokémon.")
end
	
if getPlayerLanguage(cid) == 2 then
doPlayerSendCancel(cid, "Sorry, you can't use this addon on this pokémon.")
end
return false
end
 
if getItemAttribute(pb, "pokeballusada") == 0 then
doRemoveItem(item.uid, 1)
doSendMagicEffect(fromPosition, 173)
doSetItemAttribute(pb,"addon",addon)
doSetItemAttribute(pb,"addonfly",fly)
doSetItemAttribute(pb,"addonride",ride)
doSetItemAttribute(pb,"addonsurf",surf)
doSetItemAttribute(pb,"addonlook",addonlook)
return true
end
end