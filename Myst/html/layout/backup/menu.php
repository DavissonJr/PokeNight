<ul class="sf-menu" id="nav">
	<li><a href="index.php">Home</a></li>
	<li><a href="downloads.php">Downloads</a></li>	
	<li><a href="forum.php">Forum</a></li>

	<li><a href="forum.php">Community</a>
		<ul> <!-- (sub)dropdown COMMUNITY -->
			<li><a href="onlinelist.php">Who is online?</a></li>
			<li><a href="highscores.php">Highscores</a></li>
			<li><a href="houses.php">Houses</a></li>
			<li><a href="guilds.php">Guilds</a>
			<li><a href="support.php">Staff</a></li>
<!--
			<li><a href="deaths.php">Deaths</a></li>
			<li><a href="killers.php">Killers</a></li>
			<li><a href="spells.php">Spells</a></li>
			<li><a href="serverinfo.php">Server Information</a></li>
			<li><a href="gallery.php">Gallery</a></li> -->
			<?php if ($config['items'] == true) { ?><li><a href="items.php">Items</a></li><?php } ?>
		</ul>
	</li>

	
<!--	<li><a href="shop.php">Shop</a>
		<ul> 
			<li><a href="buypoints.php">Buy Points</a></li>
			<li><a href="shop.php">Shop Offers</a></li>
		</ul>
	</li>-->

	<?php if ($config['guildwar_enabled'] === true) { ?>
		<ul>
			<li><a href="guilds.php">Guild List</a></li>
			<li><a href="guildwar.php">Guild Wars</a></li>
		</ul>
	<?php } ?></li>
<!--
	<li><a href="changelog.php">Changelog</a></li>-->

	<li><a href="helpdesk.php">Support</a></li>

	<li><a href="https://www.facebook.com/pokemonhpofc" target="_blank">Social</a>
		<ul> <!-- (sub)dropdown SOCIAL -->
			<li><a href="https://www.facebook.com/pokemonhpofc" target="_blank">Facebook</a></li>
			<li><a href="https://discord.gg/" target="_blank">Discord</a></li>
		</ul>
	</li>
<!--
	<li><a href="https://www.facebook.com/PokeDashGamesOficial/" target="_blank"><img src="layout/images/facebook_menor.png" height="30"></a></li>
	<li><a href="https://www.youtube.com/PokeDashGames/" target="_blank"><img src="layout/images/youtube.png" height="30"></a></li>-->
</ul>
