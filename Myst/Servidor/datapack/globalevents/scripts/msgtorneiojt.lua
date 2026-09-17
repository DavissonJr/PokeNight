local i = {
["08:45"] = {nome = "O torneio vai começar em 15 minutos, fale com o npc Nick no centro pokémon de kanto!!!."},
["08:59"] = {nome = "As inscrições do Torneio kanto fecharam!"},

["12:15"] = {nome = "O torneio vai começar em 15 minutos, fale com o npc Nick no centro pokémon de kanto!!!."},
["12:29"] = {nome = "As inscrições do Torneio kanto fecharam!"},


["18:45"] = {nome = "O torneio vai começar em 15 minutos, fale com o npc Nick no centro pokémon de kanto!!!. "},
["18:59"] = {nome = "As inscrições do Torneio kanto fecharam!"},


["22:45"] = {nome = "O torneio vai começar em 15 minutos, fale com o npc Nick no centro pokémon de kanto!!!."},
["22:59"] = {nome = "As inscrições do Torneio kanto fecharam!"},



}

function onThink(interval, lastExecution)
        hours = tostring(os.date("%X")):sub(1, 5)
        tb = i[hours]
        if tb then
                doBroadcastMessage(tb.nome)
                        end
        return true
end