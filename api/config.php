<?php
/**
 * Regras de criacao de conta e personagem.
 *
 * Os valores de spawn/level/outfit NAO foram inventados: saem do
 * config.lua do servidor e dos personagens reais que ja existem no banco
 * (outfit 510/511, spawn 1037,1037,7, town 1). A formula de vida
 * -- level * 60 + 360 -- foi derivada dos players existentes.
 */
declare(strict_types=1);

return [
    'account' => [
        'name_min'  => 4,
        'name_max'  => 24,
        'pass_min'  => 6,
        'pass_max'  => 64,
    ],
    'character' => [
        'name_min'  => 3,
        'name_max'  => 20,
        'level'     => 15,
        'town_id'   => 1,
        'posx'      => 1037,
        'posy'      => 1037,
        'posz'      => 7,
        'cap'       => 600,
        'vocation'  => 0,
        'group_id'  => 1,
        'looktype'  => ['male' => 510, 'female' => 511],
        'max_per_account' => 5,
    ],
    // Palavras que ninguem pode usar em nome de conta ou personagem.
    'blocked_words' => [
        'admin', 'administrador', 'gm', 'cm', 'god', 'gamemaster', 'staff',
        'tutor', 'owner', 'dono', 'suporte', 'support', 'pokeorigin', 'pko',
        'system', 'sistema', 'null', 'undefined',
    ],
];
