<?php
require_once 'engine/init.php';

// Verifique se o pagamento foi concluído
if ($_POST['event'] === 'transaction_status_changed' && $_POST['current_status'] === 'paid') {
  $transactionId = $_POST['id']; // ID da transação
  $accountId = $_POST['metadata']['account_id']; // ID da conta do jogador
  $amount = $_POST['amount']; // Valor do pagamento em centavos

  // Converta o valor do pagamento em pontos (1 ponto = 1 real)
  $points = $amount / 100;

  // Atualize os pontos na tabela de contas (accounts) do jogador
  $sql = "UPDATE accounts SET premium_points = premium_points + :points WHERE id = :account_id";
  $stmt = $pdo->prepare($sql);
  $stmt->bindParam(':points', $points, PDO::PARAM_INT);
  $stmt->bindParam(':account_id', $accountId, PDO::PARAM_INT);
  $stmt->execute();

  // Registre a transação no banco de dados, se necessário
  // ...

  // Envie uma resposta de sucesso para o Pagar.me
  http_response_code(200);
  echo 'OK';
} else {
  // Caso o pagamento não esteja concluído, você pode tratar de outra forma, se necessário
  http_response_code(400);
  echo 'Erro no pagamento';
}
?>
