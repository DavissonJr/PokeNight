local messages = {
                "Evitem acessar sites falsos! Nosso único site oficial é www.pokenight.com. Fiquem atentos e joguem com segurança!",
                "Está curtindo o servidor? Que tal convidar seus amigos para se juntarem a você? A diversão é ainda melhor quando compartilhada!",
                "Pedimos desculpas pelas quedas e bugs. Estamos trabalhando para melhorar a estabilidade. Agradecemos sua paciência.",
                "Problemas para chamar seu Pokémon ou com o comando 'order'? Vá até o Centro Pokémon e clique no computador ao lado de Nurse Joy para resolver.",
                "Roubos são estritamente proibidos. Se você tiver evidências, por favor, apresente-as à administração para que a punição adequada seja aplicada ao infrator. Juntos, mantemos a integridade do servidor.",
                "Quer expressar uma reclamação, protestar ou simplesmente conversar? Utilize o chat do jogo para isso. O canal de ajuda (help) deve ser usado exclusivamente para esclarecer dúvidas sobre o jogo, sem spoilers. Agradecemos sua cooperação!",
                "É estritamente proibido vender itens do jogo por dinheiro real. Qualquer violação dessa regra está sujeita a banimento permanente. Mantenhamos o jogo justo e divertido para todos!",
                "Todas as doações recebidas para o servidor são usadas para adquirir novos sistemas e implementar melhorias. Agradecemos imensamente a todos que estão contribuindo para tornar nossa comunidade ainda melhor!",
                "Preparem-se para a diversão! Todos os finais de semana teremos eventos especiais. Fiquem ligados para participar e ganhar prêmios incríveis!",
                }

local i = 0
function onThink(interval, lastExecution)
local message = messages[(i % #messages) + 1]
    doBroadcastMessage("" .. message,22)
    i = i + 1
    return TRUE
end