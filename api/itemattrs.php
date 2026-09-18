<?php
/**
 * Leitor dos atributos serializados de item do TFS 0.4.
 *
 * E como o servidor guarda o que ha dentro de uma pokebola: nome do
 * pokemon, level, natureza, retrato. A coluna player_items.attributes
 * traz esse fluxo em binario.
 *
 * Formato (conferido byte a byte num registro real):
 *   u8  marcador (0x80)
 *   u16 quantidade de atributos
 *   por atributo:
 *     u16 tamanho da chave, chave
 *     u8  tipo
 *       1 = string  -> u32 tamanho + bytes
 *       2 = inteiro -> i32
 *       3 = double  -> 8 bytes
 *       4 = boolean -> u8
 */
declare(strict_types=1);

/**
 * Decodifica o blob e devolve um mapa chave => valor.
 * Qualquer inconsistencia interrompe a leitura e devolve o que deu certo
 * ate ali -- um item corrompido nao pode derrubar a listagem inteira.
 */
function pko_parse_item_attributes(string $blob): array
{
    $len = strlen($blob);
    if ($len < 3 || ord($blob[0]) !== 0x80) {
        return [];
    }

    $count = unpack('v', substr($blob, 1, 2))[1];
    $out = [];
    $i = 3;

    for ($n = 0; $n < $count; $n++) {
        if ($i + 2 > $len) {
            break;
        }
        $keyLen = unpack('v', substr($blob, $i, 2))[1];
        $i += 2;
        if ($keyLen <= 0 || $i + $keyLen + 1 > $len) {
            break;
        }
        $key = substr($blob, $i, $keyLen);
        $i += $keyLen;

        $type = ord($blob[$i]);
        $i += 1;

        if ($type === 1) {
            if ($i + 4 > $len) {
                break;
            }
            $vLen = unpack('V', substr($blob, $i, 4))[1];
            $i += 4;
            if ($vLen < 0 || $i + $vLen > $len) {
                break;
            }
            $out[$key] = substr($blob, $i, $vLen);
            $i += $vLen;
        } elseif ($type === 2) {
            if ($i + 4 > $len) {
                break;
            }
            $out[$key] = unpack('l', substr($blob, $i, 4))[1];
            $i += 4;
        } elseif ($type === 3) {
            if ($i + 8 > $len) {
                break;
            }
            $out[$key] = unpack('d', substr($blob, $i, 8))[1];
            $i += 8;
        } elseif ($type === 4) {
            if ($i + 1 > $len) {
                break;
            }
            $out[$key] = ord($blob[$i]) !== 0;
            $i += 1;
        } else {
            break;   // tipo desconhecido: nao da para saber quanto pular
        }
    }

    return $out;
}
