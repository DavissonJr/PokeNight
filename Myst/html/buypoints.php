<?php require_once 'engine/init.php';
protect_page();
include 'layout/overall/header.php';
?>

<div><center>
<td>Você possuí <?php echo (int)($user_znote_data['points'] - $buy['points']); ?> diamonds.</td>
<br>
<h2>Compre diamonds:</h2>
    <a href="https://iti.itau/receber-pix/?chargeId=a1364c75-526c-4554-9e27-2878399c4043" >  PAGUE VIA PIX  </a>

</div></center>
<?php include 'layout/overall/footer.php' ?>