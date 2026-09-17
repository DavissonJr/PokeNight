-- [
    --~~ Thalles Vitor ~~--
--]

-- Essa tabela e para a criacao de pokes para o uso de math random
NATURE_TABLE_NEWPOKE = {
	[1] = {nature = "Hardy"},
	[2] = {nature = "Lonely"},
	[3] = {nature = "Brave"},
	[4] = {nature = "Bold"},
	[5] = {nature = "Docile"},
	[6] = {nature = "Relaxed"},
	[7] = {nature = "Timid"},
	[8] = {nature = "Hasty"},
	[9] = {nature = "Serious"},
	[10] = {nature = "Jolly"},
	[11] = {nature = "Naive"},
	[12] = {nature = "Modest"},
	[13] = {nature = "Mild"},
	[14] = {nature = "Quiet"},
	[15] = {nature = "Bashful"},
	[16] = {nature = "Rash"},
	[17] = {nature = "Calm"},
	[18] = {nature = "Gentle"},
	[19] = {nature = "Sassy"},
	[20] = {nature = "Careful"},
	[21] = {nature = "Quirky"},
	[22] = {nature = "Adamant"},
}

-- Essa tabela e para dar buff la no level system
-- Ordem da list:
-- attack
-- defense
-- agility
-- vitality
-- specialattack
-- list_operator: Aceita: "+", "-" e "*"
-- Explicacao de Operadores: + (SOMA) / - (SUBTRA��O) / * (MULTIPLICA��O)
NATURE_TABLE_SYSTEM = {
	["Hardy"] = {list = {1.5, 0.2, 0.2, 0.2, 0.2}, list_operator = {"*", "+", "+", "+", "*"}},
	["Lonely"] = {list = {2.0, 3.2, 0.2, 0.2, 2.2}, list_operator = {"*", "-", "+", "+", "*"}},
	["Brave"] = {list = {2.0, 2.5, 0.2, 0.2, 2.2}, list_operator = {"*", "-", "+", "+", "*"}},
	["Adamant"] = {list = {2.0, 0.2, 0.2, 0.2, 0.2}, list_operator = {"*", "+", "+", "+", "+"}},
	["Naughty"] = {list = {2.0, 2.5, 0.2, 0.2, 0.2}, list_operator = {"*", "-", "+", "+", "+"}},
	["Bold"] = {list = {2.2, 0.2, 0.2, 0.2, 2.2}, list_operator = {"*", "+", "+", "+", "+"}},
	["Docile"] = {list = {0.2, 2.5, 0.2, 0.2, 2.2}, list_operator = {"+", "*", "+", "+", "+"}},
	["Relaxed"] = {list = {5.0, 0.2, 3.0, 0.2, 2.2}, list_operator = {"*", "+", "-", "+", "+"}},
	["Timid"] = {list = {2.0, 0.2, 2.2, 0.2, 2.2}, list_operator = {"-", "+", "*", "+", "+"}},
	["Hasty"] = {list = {0.2, 2.0, 3.2, 0.2, 2.2}, list_operator = {"+", "-", "*", "+", "+"}},
	["Serious"] = {list = {0.2, 0.2, 3.5, 0.2, 2.2}, list_operator = {"+", "+", "*", "+", "+"}},
	["Jolly"] = {list = {0.2, 0.2, 3.5, 0.2, 2.2}, list_operator = {"+", "+", "*", "+", "-"}},
	["Naive"] = {list = {0.2, 3.5, 3.5, 0.2, 2.2}, list_operator = {"+", "-", "*", "+", "+"}},
	["Modest"] = {list = {2.5, 0.2, 0.2, 0.2, 3.5}, list_operator = {"-", "+", "+", "+", "*"}},
	["Mild"] = {list = {0.2, 2.5, 0.2, 0.2, 3.5}, list_operator = {"+", "-", "+", "+", "*"}},
	["Quiet"] = {list = {0.2, 0.2, 2.5, 0.2, 3.5}, list_operator = {"+", "+", "-", "+", "*"}},
	["Bashful"] = {list = {0.2, 0.2, 0.2, 0.2, 3.5}, list_operator = {"+", "+", "+", "+", "*"}},
	["Rash"] = {list = {0.2, 3.5, 0.2, 0.2, 3.5}, list_operator = {"+", "-", "+", "+", "*"}},
	["Calm"] = {list = {2.2, 3.5, 0.2, 0.2, 3.5}, list_operator = {"-", "*", "+", "+", "+"}},
	["Gentle"] = {list = {0.2, 3.5, 0.2, 0.2, 0.2}, list_operator = {"+", "-", "+", "+", "+"}},
	["Sassy"] = {list = {0.2, 3.5, 2.5, 0.2, 0.2}, list_operator = {"+", "*", "-", "+", "+"}},
	["Careful"] = {list = {0.2, 3.5, 0.2, 0.2, 3.5}, list_operator = {"+", "*", "-", "+", "-"}},
	["Quirky"] = {list = {0.2, 3.5, 0.2, 0.2, 0.2}, list_operator = {"+", "*", "+", "+", "+"}},
}