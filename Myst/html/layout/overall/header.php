<?php
	require_once 'layout/layout_config.php';
	$launch_seconds = (strtotime($countDown) - time());
	$delay_hide = $launch_seconds + $countDown_hide;
?>
<!DOCTYPE html>
<html lang="en" dir="ltr">
	<head>
		<meta charset="utf-8">
		<title><?php echo $config['site_title']; ?></title>

		<!-- Stylesheet(s) -->
		<link rel="stylesheet" href="layout/css/style.css">
		<link rel="stylesheet" href="layout/fontawesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="layout/css/resp.css">

		<!-- JavaScript(s) -->
		<script src="layout/js/jq331.js" charset="utf-8"></script>
		
		<?php if ($delay_hide > 0): ?>
			<script src="layout/js/countdown.js" charset="utf-8"></script>
		<?php endif; ?>
		
		<script type="text/javascript">
			$(document).ready(function(){
				<?php if ($delay_hide > 0): ?>
					countDown("countDownTimer", <?php echo $launch_seconds; ?>, "<?php echo $countDown_complete; ?>");
				<?php endif; ?>
				
				$('.loginBtn').click(function(){
					$('.loginContainer input:first-of-type').focus();
				});
				$('#accountLink').click(function(e) {
					if (this.href.indexOf('#') >= 0) {
						console.log("hello", this.href, this.href.indexOf('#'));
						$('.loginContainer input:first-of-type').focus();
					}
				});
			});
		</script>
	</head>
	<body<?php if (isset($page_filename) && strlen($page_filename) > 0) echo " class='page_{$page_filename}'"; ?>>
		
		
		<!-- Main container -->
		<div class="main">
			<?php include 'layout/menu.php'; ?>

			<div class="well banner"></div>

			<div class="well feedContainer preventCollapse">
				<?php if ($delay_hide > 0): ?>
					<div class="well topPane preventCollapse">
						<div class="well pull-left">
							<div id="countDownTimer" data-date="<?=$countDown?>"></div>
						</div>
					</div>
			<?php endif; ?>
				<!-- MAIN FEED -->
				<!-- TESTE -->
		<div class="well topPane preventCollapse">
					
					<div style="float: right; width: 53px;"><a href="https://discord.gg/PGKdE9PMrq" target="_blank"><img src="layout/img/discordico.png" width="100%"></a></div>
					<div style="float: right; width: 53px;"><a href="https://discord.gg/PGKdE9PMrq" target="_blank"><img src="layout/img/instaico.png" width="100%"></a></div>
					<div style="float: right; width: 53px;"><a href="https://discord.gg/PGKdE9PMrq" target="_blank"><img src="layout/img/facebookico.png" width="100%"></a></div>
					
											<div style="float: right; width: 53px; margin-right: 80px; margin-top: 12px;"><a href="downloads.php" class="topDownloadButton"> Baixar </a></div>
									</div>
				<div class="pull-left leftPane">