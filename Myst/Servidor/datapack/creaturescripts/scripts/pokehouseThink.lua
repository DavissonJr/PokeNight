-- Criado por Thalles Vitor --
-- Sistema de Poke House --

local dirs = {NORTH, EAST, WEST, NORTHEAST, SOUTHEAST, SOUTH}

function moverCriatura(cid)
    if not isCreature(cid) then
        return true
    end

    doMoveCreature(cid, dirs[math.random(1, #dirs)])
    addEvent(moverCriatura, 500, cid)
    return true
end

function onThink(cid)
    if not isMonster(cid) then
        return true
    end

	moverCriatura(cid)
    return true
end