<?php
require_once 'engine/init.php';
logged_in_redirect();
include 'layout/overall/header.php';
require_once('config.countries.php');

if (empty($_POST) === false) {
	// $_POST['']
	$required_fields = array('username', 'password', 'password_again', 'email', 'selected');
	foreach($_POST as $key=>$value) {
		if (empty($value) && in_array($key, $required_fields) === true) {
			$errors[] = 'Você precisa preencher todos os campos.';
			break 1;
		}
	}

	// check errors (= user exist, pass long enough
	if (empty($errors) === true) {
		/* Token used for cross site scripting security */
		if (!Token::isValid($_POST['token'])) {
			$errors[] = 'O token é inválido.';
		}

		if ($config['use_captcha']) {
			$captcha = (isset($_POST['g-recaptcha-response'])) ? $_POST['g-recaptcha-response'] : false;
			if(!$captcha) {
				$errors[] = 'Por favor, verifique o formulário captcha.';
			} else {
				$secretKey = $config['captcha_secret_key'];
				$ip = $_SERVER['REMOTE_ADDR'];
				// curl start
				$curl_connection = curl_init("https://www.google.com/recaptcha/api/siteverify");
				$post_string = "secret=".$secretKey."&response=".$captcha."&remoteip=".$ip;
				curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 5);
				curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
				curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 0);
				curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
				$response = curl_exec($curl_connection);
				curl_close($curl_connection);
				// Curl end
				$responseKeys = json_decode($response,true);
				if(intval($responseKeys["success"]) !== 1) {
					$errors[] = 'CAPTCHA falhou.';
				}
			}
		}

		if (user_exist($_POST['username']) === true) {
			$errors[] = 'Desculpe, esse nome de usuário já existe.';
		}
		
		// Não permita acesso de "nomes de admin padrão no config.php" para registro.
		$isNoob = in_array(strtolower($_POST['username']), $config['page_admin_access']) ? true : false;
		if ($isNoob) {
			$errors[] = 'Este nome de conta está bloqueado para registro.';
		}
		if (preg_match("/^[a-zA-Z0-9]+$/", $_POST['username']) == false) {
			$errors[] = 'Seu nome de conta pode conter apenas letras de a-z, A-Z e números 0-9.';
		}
		
		// restrição de nome
		$resname = explode(" ", $_POST['username']);
		foreach($resname as $res) {
			if(in_array(strtolower($res), $config['invalidNameTags'])) {
				$errors[] = 'Seu nome de usuário contém uma palavra restrita.';
			}
			else if(strlen($res) == 1) {
				$errors[] = 'Palavras muito curtas no seu nome.';
			}
		}
		if (strlen($_POST['username']) > 32) {
			$errors[] = 'Seu nome de conta deve ter menos de 33 caracteres.';
		}
		// fim da restrição de nome
		
		if (strlen($_POST['password']) < 6) {
			$errors[] = 'Sua senha deve ter pelo menos 6 caracteres.';
		}
		if (strlen($_POST['password']) > 100) {
			$errors[] = 'Sua senha deve ter menos de 100 caracteres.';
		}
		if ($_POST['password'] !== $_POST['password_again']) {
			$errors[] = 'Suas senhas não coincidem.';
		}
		if (filter_var($_POST['email'], FILTER_VALIDATE_EMAIL) === false) {
			$errors[] = 'É necessário um endereço de email válido.';
		}
		if (user_email_exist($_POST['email']) === true) {
			$errors[] = 'Esse endereço de email já está em uso.';
		}
		if ($_POST['selected'] != 1) {
			$errors[] = 'Você só pode ter uma conta se aceitar as regras.';
		}
		if (validate_ip(getIP()) === false && $config['validate_IP'] === true) {
			$errors[] = 'Não foi possível reconhecer seu endereço IP. (Endereço IPv4 inválido).';
		}
		if (strlen($_POST['flag']) < 1) {
			$errors[] = 'Por favor, escolha um país.';
		}
		
	}
}

?>
<h1>Criar uma conta</h1>
<?php
if (isset($_GET['success']) && empty($_GET['success'])) {
	if ($config['mailserver']['register']) {
		?>
		<h1>Autenticação por email necessária</h1>
        <p>Nós enviamos um email com um link de ativação para o endereço de email fornecido.</p>
        <p>Se você não encontrar o email dentro de 5 minutos, verifique sua <strong>caixa de entrada de lixo/spam (filtro de spam)</strong>, pois ele pode ter sido direcionado para lá por engano.</p>
		<?php
	} else echo 'Parabéns! Sua conta foi criada. Agora você pode fazer login para criar um personagem.';
} elseif (isset($_GET['authenticate']) && empty($_GET['authenticate'])) {
	// Authenticate user, fetch user id and activation key
	$auid = (isset($_GET['u']) && (int)$_GET['u'] > 0) ? (int)$_GET['u'] : false;
	$akey = (isset($_GET['k']) && (int)$_GET['k'] > 0) ? (int)$_GET['k'] : false;
	// Find a match
	$user = mysql_select_single("SELECT `id`, `active` FROM `znote_accounts` WHERE `account_id`='$auid' AND `activekey`='$akey' LIMIT 1;");
	if ($user !== false) {
		$user = (int) $user['id'];
		$active = (int) $user['active'];
		// Enable the account to login
		if ($active == 0) {
			mysql_update("UPDATE `znote_accounts` SET `active`='1' WHERE `id`= $user LIMIT 1;");
	}
		echo '<h1>Parabéns!</h1> <p>Sua conta foi criada. Agora você pode fazer login para criar um personagem.</p>';
	} else {
		echo '<h1>Falha na autenticação</h1> <p>Ou o link de ativação está incorreto, ou sua conta já está ativada.</p>';
}
		
} else {
	if (empty($_POST) === false && empty($errors) === true) {
		if ($config['log_ip']) {
			znote_visitor_insert_detailed_data(1);
		}

		//Register
		$register_data = array(
			'name'		=>	$_POST['username'],
			'password'	=>	$_POST['password'],
			'email'		=>	$_POST['email'],
			'created'	=>	time(),
			'ip'		=>	getIPLong(),
			'flag'		=> 	$_POST['flag']
		);

		user_create_account($register_data, $config['mailserver']);
		if (!$config['mailserver']['debug']) header('Location: register.php?success');
		exit();
		//End register

	} else if (empty($errors) === false){
		echo '<font color="red"><b>';
		echo output_errors($errors);
		echo '</b></font>';
	}
?>
	<form action="" method="post">
		<ul>
			<li>
				Nome da conta:<br>
				<input type="text" name="username">
			</li>
			<li>
				Senha da conta:<br>
				<input type="password" name="password">
			</li>
			<li>
				Senha novamente:<br>
				<input type="password" name="password_again">
			</li>
			<li>
				E-mail:<br>
				<input type="text" name="email">
			</li>
			<li>
				País:<br>
				<select name="flag">
					<option value="">Escolha</option>
					<?php
					foreach(array('pl', 'se', 'br', 'us', 'gb', ) as $c)
						echo '<option value="' . $c . '">' . $config['countries'][$c] . '</option>';

						echo '<option value="">----------</option>';
						foreach($config['countries'] as $code => $c)
							echo '<option value="' . $code . '">' . $c . '</option>';
					?>
				</select>
			</li>
			<?php
			if ($config['use_captcha']) {
				?>
				<li>
					 <div class="g-recaptcha" data-sitekey="<?php echo $config['captcha_site_key']; ?>"></div>
				</li>
				<?php
			}
			?>
			<li>
				<h2>Regras do Servidor</h2>
				<p>Para acessar nossas regras, visite nosso Discord. Estão todas lá!</p>
			</li>
			<li>
				<select name="selected">
				  <option value="1">Ok</option>
				</select>
			</li>
			<?php
				/* Form file */
				Token::create();
			?>
			<li>
				<input type="submit" value="Criar conta">
			</li>
		</ul>
	</form>
<?php
}
include 'layout/overall/footer.php';
?>
