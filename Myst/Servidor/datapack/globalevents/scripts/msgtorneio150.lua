local i = {
["08:45"] = {nome = "O torneio lvl -150 Vai comecar em 15 minutos, fale com npc Antonio no centro pokémon de Johto!!!."},
["09:01"] = {nome = "As inscrições do Torneio de Johto lvl 150- fecharam!"},

["12:15"] = {nome = "O torneio lvl -150 Vai comecar em 15 minutos, fale com npc Antonio no centro pokémon de Johto!!!."},
["12:31"] = {nome = "As inscrições do Torneio de Johto lvl 150- fecharam!"},


["18:45"] = {nome = "O torneio lvl -150 Vai comecar em 15 minutos, fale com npc Antonio no centro pokémon de Johto!!!. "},
["19:01"] = {nome = "As inscrições do Torneio de Johto lvl 150- fecharam!"},


["22:45"] = {nome = "O torneio lvl -150 Vai comecar em 15 minutos, fale com npc Antonio no centro pokémon de Johto!!!."},
["23:01"] = {nome = "As inscrições do Torneio de Johto lvl 150- fecharam!"},




}

function onThink(interval, lastExecution)
        hours = tostring(os.date("%X")):sub(1, 5)
        tb = i[hours]
        if tb then
                doBroadcastMessage(tb.nome)
                        end
        return true
end