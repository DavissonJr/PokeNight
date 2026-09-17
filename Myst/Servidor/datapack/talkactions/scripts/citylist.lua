function onSay(cid, words, param)

-- local msg = "Ciries List:"

local msg = [[
                      Lista de Cidades :
-------------------------------------------------
                             KANTO:

  *Saffron
  *Cerulean
  *Lavender
  *Fuchsia
  *Celadon
  *Pallet
  *Viridian
  *Vermilion
  *Cinnabar

-------------------------------------------------

                             HOENN:

  *Larosse
  *Orre
  *Canavale

--------------------------------------------------------

                             JOHTO:
                   
  *Goldenrod
  *Azalea
  *Ecruteak
  *Olivine
  *Violet
  *Cherrygrove
  *New Bark
  *Mahogany
  *Black City

-------------------------------------------------------

                      ORANGE ISLANDS

  *Hamlin Island
]]

doPlayerPopupFYI(cid, msg)

return true
end