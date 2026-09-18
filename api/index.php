<?php
/**
 * API do PokeOrigin -- consumida pelo cliente via g_http.
 *
 * Fala JSON puro, sem sessao e sem CSRF: quem chama e o jogo, nao um
 * navegador. Cada rota valida a propria entrada e devolve sempre o mesmo
 * formato { ok: bool, ... }, para o Lua tratar de um jeito so.
 */
declare(strict_types=1);

require __DIR__ . '/db.php';
$CFG = require __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');

function reply(array $payload, int $status = 200)
{
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE);
    exit;
}

function fail(string $message, int $status = 400)
{
    reply(['ok' => false, 'error' => $message], $status);
}

/** Le o corpo como JSON, caindo para form-urlencoded se preciso. */
function input(): array
{
    $raw = file_get_contents('php://input') ?: '';
    $data = json_decode($raw, true);
    if (is_array($data)) {
        return $data;
    }
    return $_POST ?: [];
}

function has_blocked_word(string $value, array $blocked): bool
{
    $lower = mb_strtolower($value);
    foreach ($blocked as $word) {
        if (strpos($lower, $word) !== false) {
            return true;
        }
    }
    return false;
}

$route  = trim($_GET['r'] ?? '', '/');
$method = $_SERVER['REQUEST_METHOD'];

try {
    $db = pko_db();
} catch (Throwable $e) {
    fail('Servidor indisponivel no momento.', 503);
}

switch ($route) {

    // ---- GET /?r=status -------------------------------------------------
    case 'status':
        $online = (int) $db->query('SELECT COUNT(*) FROM players WHERE online = 1')->fetchColumn();
        reply(['ok' => true, 'online' => $online, 'server' => 'PokeOrigin']);

    // ---- GET /?r=check-account&name=... ---------------------------------
    case 'check-account':
        $name = trim($_GET['name'] ?? '');
        if ($name === '') {
            fail('Informe um nome de conta.');
        }
        $st = $db->prepare('SELECT 1 FROM accounts WHERE name = ? LIMIT 1');
        $st->execute([$name]);
        reply(['ok' => true, 'available' => $st->fetchColumn() === false]);

    // ---- GET /?r=check-character&name=... -------------------------------
    case 'check-character':
        $name = trim($_GET['name'] ?? '');
        if ($name === '') {
            fail('Informe um nome de personagem.');
        }
        $st = $db->prepare('SELECT 1 FROM players WHERE name = ? LIMIT 1');
        $st->execute([$name]);
        reply(['ok' => true, 'available' => $st->fetchColumn() === false]);

    // ---- POST /?r=register ----------------------------------------------
    case 'register':
        if ($method !== 'POST') {
            fail('Metodo invalido.', 405);
        }
        $in    = input();
        $name  = trim((string) ($in['name'] ?? ''));
        $pass  = (string) ($in['password'] ?? '');
        $email = trim((string) ($in['email'] ?? ''));
        $rules = $CFG['account'];

        $len = mb_strlen($name);
        if ($len < $rules['name_min'] || $len > $rules['name_max']) {
            fail("O nome da conta precisa ter entre {$rules['name_min']} e {$rules['name_max']} caracteres.");
        }
        if (!preg_match('/^[a-zA-Z0-9_]+$/', $name)) {
            fail('O nome da conta aceita apenas letras, numeros e underline.');
        }
        if (has_blocked_word($name, $CFG['blocked_words'])) {
            fail('Esse nome de conta nao esta disponivel.');
        }
        $plen = mb_strlen($pass);
        if ($plen < $rules['pass_min'] || $plen > $rules['pass_max']) {
            fail("A senha precisa ter entre {$rules['pass_min']} e {$rules['pass_max']} caracteres.");
        }
        if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            fail('E-mail invalido.');
        }

        $st = $db->prepare('SELECT 1 FROM accounts WHERE name = ? LIMIT 1');
        $st->execute([$name]);
        if ($st->fetchColumn() !== false) {
            fail('Ja existe uma conta com esse nome.');
        }

        // sha1 puro, sem salt: e o que o servidor espera
        // (encryptionType = "sha1" no config.lua, coluna password com 40 chars).
        $st = $db->prepare(
            "INSERT INTO accounts (name, password, salt, email, created) VALUES (?, ?, '', ?, ?)"
        );
        $st->execute([$name, sha1($pass), $email, time()]);

        reply(['ok' => true, 'account_id' => (int) $db->lastInsertId(), 'name' => $name]);

    // ---- POST /?r=create-character --------------------------------------
    case 'create-character':
        if ($method !== 'POST') {
            fail('Metodo invalido.', 405);
        }
        $in   = input();
        $acc  = trim((string) ($in['account'] ?? ''));
        $pass = (string) ($in['password'] ?? '');
        $name = trim(preg_replace('/\s+/', ' ', (string) ($in['name'] ?? '')));
        $sex  = (($in['sex'] ?? 'male') === 'female') ? 'female' : 'male';
        $c    = $CFG['character'];

        $st = $db->prepare('SELECT id FROM accounts WHERE name = ? AND password = ? LIMIT 1');
        $st->execute([$acc, sha1($pass)]);
        $accountId = $st->fetchColumn();
        if ($accountId === false) {
            fail('Conta ou senha incorreta.', 401);
        }

        $len = mb_strlen($name);
        if ($len < $c['name_min'] || $len > $c['name_max']) {
            fail("O nome do personagem precisa ter entre {$c['name_min']} e {$c['name_max']} caracteres.");
        }
        if (!preg_match('/^[a-zA-Z ]+$/', $name)) {
            fail('O nome do personagem aceita apenas letras e espacos.');
        }
        if (substr_count($name, ' ') > 1) {
            fail('O nome pode ter no maximo duas palavras.');
        }
        if (has_blocked_word($name, $CFG['blocked_words'])) {
            fail('Esse nome de personagem nao esta disponivel.');
        }

        $st = $db->prepare('SELECT 1 FROM players WHERE name = ? LIMIT 1');
        $st->execute([$name]);
        if ($st->fetchColumn() !== false) {
            fail('Ja existe um personagem com esse nome.');
        }

        $st = $db->prepare('SELECT COUNT(*) FROM players WHERE account_id = ?');
        $st->execute([$accountId]);
        if ((int) $st->fetchColumn() >= $c['max_per_account']) {
            fail("Limite de {$c['max_per_account']} personagens por conta atingido.");
        }

        // Vida derivada dos personagens reais do servidor: level * 60 + 360.
        $hp = $c['level'] * 60 + 360;

        $st = $db->prepare(
            "INSERT INTO players
             (name, account_id, group_id, level, vocation, health, healthmax,
              mana, manamax, cap, town_id, posx, posy, posz, looktype, sex,
              conditions, created)
             VALUES (?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, ?, ?, ?, ?, '', ?)"
        );
        $st->execute([
            $name, $accountId, $c['group_id'], $c['level'], $c['vocation'],
            $hp, $hp, $c['cap'], $c['town_id'],
            $c['posx'], $c['posy'], $c['posz'],
            $c['looktype'][$sex], ($sex === 'female') ? 0 : 1,
            time(),
        ]);

        reply(['ok' => true, 'character' => $name, 'id' => (int) $db->lastInsertId()]);

    default:
        fail('Rota desconhecida.', 404);
}
