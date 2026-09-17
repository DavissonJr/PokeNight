<?php
require_once 'engine/init.php';
protect_page();

// Verifique se a quantidade e outras informações necessárias são fornecidas
if (isset($_POST['quantity'])) {
    $quantity = intval($_POST['quantity']);

    // Defina outras informações necessárias para o pagamento
    $encryptionKey = 'sk_aOLgXAxH1IPGm4R0'; // Sua chave de criptografia do Pagar.me
    $amount = $quantity * 100; // Multiplica a quantidade pelos pontos pelo valor de cada ponto (100)

    // Construa o payload JSON para a criação do pedido de checkout
    $payload = [
        'payments' => [
            [
                'amount' => $amount,
                'payment_method' => 'checkout',
                'checkout' => [
                    'expires_in' => 120,
                    'billing_address_editable' => false,
                    'customer_editable' => true,
                    'accepted_payment_methods' => ['credit_card'],
                    'success_url' => 'https://www.pagar.me',
                ],
            ],
        ],
    ];

    // Realize a requisição para a API do Pagar.me
    $ch = curl_init('https://api.pagar.me/checkout/v5/orders/');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    curl_setopt($ch, CURLOPT_USERPWD, $encryptionKey . ':'); // Utilize sua chave de criptografia como usuário

    $response = curl_exec($ch);

    // Verifique se houve erros na requisição
    if ($response === false) {
        die('Erro na requisição: ' . curl_error($ch));
    }

    // Redirecione o usuário para a página de pagamento
    $responseData = json_decode($response, true);
    $paymentUrl = $responseData['payment_url'];
    header("Location: $paymentUrl");
    exit;
} else {
    // Redirecione o usuário de volta caso não tenha fornecido a quantidade
    header("Location: index.php");
    exit;
}
?>
