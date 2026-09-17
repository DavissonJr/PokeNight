function onSay(cid, words)
local msg = [[ Bom o sistema de Vitamina Fuciona da seguinte forma:


•1- Você vai ate o npc Rudy, que se localiza no Trade center.


•2- Vá ate ele e diga: "hi" e logo após diga "Trade".


•3- Ele vai lhe mostra uma lista das Vitaminas que ele vende.


•4- Compre a que você quizer por 50hd.


•5-logo após puxe seu pokemon para a pokebola, e use as 
   Vitaminas dando USE.



------ OBS: cada vitamina almentar 30 potos da ------ 
            sua especialidade.
]]

doPlayerPopupFYI(cid, msg)
return true
end