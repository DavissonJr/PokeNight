<div class="well loginContainer widget" id="loginContainer">
	<div class="header">
		Entrar
	</div>
	<div class="body">
		<form class="loginForm" action="login.php" method="post">
			<div class="well">
				<label for="login_username">Nome da conta:</label> <input type="text" name="username" id="login_username">
			</div>
			<div class="well">
				<label for="login_password">Senha da conta:</label> <input type="password" name="password" id="login_password">
			</div>
			<?php if ($config['twoFactorAuthenticator']): ?>
				<div class="well">
					<label for="login_password">Token:</label> <input type="password" name="authcode">
				</div>
			<?php endif; ?>
			<div class="well">
				<input type="submit" value="Entrar" class="submitButton">
			</div>
			<?php
				/* Form file */
				Token::create();
			?>
		</form>
	</div>
</div>
