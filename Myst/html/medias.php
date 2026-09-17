<?php
require_once 'engine/init.php';
include 'layout/overall/header.php';
?>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pesquisa de Médias Pokémon</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
    }

    
    @keyframes fadeIn {
      0% { opacity: 0; transform: translateY(-20px); }
      100% { opacity: 1; transform: translateY(0); }
    }
    
    .title {
      text-align: center;
      font-size: 28px;
      margin-bottom: 20px;
    }
    
    .input-container {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-bottom: 20px;
      animation: slideIn 0.5s ease-in-out;
    }
    
    @keyframes slideIn {
      0% { opacity: 0; transform: translateX(-20px); }
      100% { opacity: 1; transform: translateX(0); }
    }
    
    .input {
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
      margin-right: 10px;
      width: 200px;
      font-size: 16px;
    }
    
    .button {
      padding: 10px 20px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 16px;
      cursor: pointer;
    }
    
    .button:hover {
      background-color: #0056b3;
    }
    
    #resultContainer {
      display: none;
      text-align: center;
      margin-top: 20px;
      animation: fadeIn 0.5s ease-in-out;
    }
    
    .subtitle {
      font-size: 20px;
      margin-bottom: 10px;
    }
    
    #average {
      font-weight: bold;
    }
    
    #message {
      margin-top: 10px;
    }
    
    ul {
      list-style-type: disc;
      margin-bottom: 20px;
      margin-left: 20px;
      animation: fadeIn 0.5s ease-in-out;
    }
    
    li {
      margin-bottom: 10px;
    }
  </style>
</head>

<body>
  <div class="container">
    <h1 class="title">Pesquisa de Médias Pokémon!</h1>
    <div class="input-container">
      <input id="pokemonInput" class="input" type="text" placeholder="Nome do Pokémon">
      <input type="submit" id="searchButton" class="button" value="Pesquisar">
    </div>
    
    <div id="resultContainer">
      <h2 class="subtitle">Média: <img src="https://2.bp.blogspot.com/-7bI5Tl-lYhw/VgpSuH1EtTI/AAAAAAAAB6Y/QHgoXSXgd_4/s1600/ultra-ball.PNG" alt="Ultra Ball" width="25"> <span id="average"></span></h2>
      <p id="message"></p>
    </div>
    
    <ul>
      <li>O Sistema de Captura <b>não garante lucro</b>. Ocasionalmente, é possível — e bem provável — que você gaste mais balls do que o Pokémon vale para conseguir capturá-lo.</li>
      <li>Qualquer quantidade de balls utilizadas para capturar um Pokémon pode ser considerada normal; é falta de sorte. Como o Sistema de Captura é integrado, é <b>impossível</b> que uma única captura contenha bug. Em outras palavras, se surgisse um bug nesse sistema, afetaria todos os jogadores simultaneamente e os impediria de capturar qualquer Pokémon.</li>
    </ul>
  </div>
  
  <script>
    const pokemonData = {
               "Abra": 13,
		"Aggron": 479,
		"Aipom": 121,
		"Abra": 13,
		"Aggron": 479,
		"Aipom": 121,
		"Alakazam": 234,
		"Altaria": 600,
		"Ampharos": 259,
		"Arbok": 43,
		"Arcanine": 303,
		"Ariados": 43,
		"Aron": 217,
		"Azumarill": 190,
		"Bagon": 433,
		"Baltoy": 52,
		"Banette": 200,
		"Barboach": 43,
		"Bayleef": 121,
		"Beautifly": 226,
		"Beedrill": 30,
		"Beldum": 217,
		"Bellossom": 173,
		"Bellsprout": 2,
		"Blastoise": 200,
		"Blaziken": 259,
		"Blissey": 363,
		"Breloom": 200,
		"Bulbasaur": 43,
		"Butterfree": 30,
		"Cacnea": 80,
		"Cacturn": 665,
		"Camerupt": 200,
		"Carvanha": 65,
		"Cascoon": 66,
		"Castform Fire": 800,
		"Castform Water": 800,
		"Castform": 800,
		"Caterpie": 0.5,
		"Chansey": 165,
		"Charizard": 200,
		"Charmander": 43,
		"Charmeleon": 121,
		"Chikorita": 43,
		"Chinchou": 16,
		"Clamperl": 47,
		"Claydol": 200,
		"Clefable": 200,
		"Clefairy": 121,
		"Cleffa": 43,
		"Cloyster": 148,
		"Combusken": 121,
		"Corphish": 52,
		"Corsola": 128,
		"Crawdaunt": 200,
		"Crobat": 600,
		"Croconaw": 121,
		"Cubone": 16,
		"Cyndaquil": 43,
		"Delcatty": 120,
		"Delibird": 148,
		"Dewgong": 173,
		"Diglett": 3,
		"Dodrio": 86,
		"Doduo": 9,
		"Donphan": 213,
		"Dragonair": 332,
		"Dragonite": 600,
		"Dratini": 200,
		"Drowzee": 16,
		"Dugtrio": 43,
		"Dunsparce": 43,
		"Dusclops": 200,
		"Duskull": 121,
		"Dustox": 226,
		"Eevee": 86,
		"Ekans": 3,
		"Electabuzz": 609,
		"Electrike": 52,
		"Electrode": 43,
		"Elekid": 128,
		"Espeon": 259,
		"Exeggcute": 4,
		"Exeggutor": 217,
		"Exploud": 200,
		"Farfetch'd": 121,
		"Fearow": 78,
		"Feebas": 77,
		"Feraligatr": 259,
		"Flaaffy": 121,
		"Flareon": 259,
		"Flygon": 840,
		"Forretress": 148,
		"Furret": 60,
		"Gardevoir": 665,
		"Gastly": 43,
		"Gengar": 173,
		"Geodude": 3,
		"Girafarig": 600,
		"Glalie": 200,
		"Gligar": 121,
		"Gloom": 33,
		"Golbat": 43,
		"Goldeen": 2,
		"Golduck": 172,
		"Golem": 217,
		"Gorebyss": 126,
		"Granbull": 182,
		"Graveler": 78,
		"Grimer": 5,
		"Grovyle": 121,
		"Growlithe": 42,
		"Grumpig": 200,
		"Gulpin": 153,
		"Gyarados": 600,
		"Hariyama": 200,
		"Haunter": 121,
		"Heracross": 800,
		"Hoothoot": 23,
		"Hoppip": 3,
		"Horsea": 2,
		"Houndoom": 200,
		"Houndour": 53,
		"Huntail": 126,
		"Hypno": 86,
		"Igglybuff": 43,
		"Illumise": 66,
		"Ivysaur": 121,
		"Jigglypuff": 121,
		"Jolteon": 259,
		"Jumpluff": 173,
		"Jynx": 600,
		"Kadabra": 47,
		"Kakuna": 2,
		"Kangaskhan": 800,
		"Kecleon": 500,
		"Kingdra": 864,
		"Kingler": 78,
		"Kirlia": 120,
		"Koffing": 5,
		"Krabby": 2,
		"Lairon": 294,
		"Lanturn": 173,
		"Lapras": 800,
		"Larvitar": 217,
		"Ledian": 43,
		"Ledyba": 5,
		"Lickitung": 800,
		"Linoone": 120,
		"Lombre": 121,
		"Lotad": 43,
		"Loudred": 121,
		"Lucario": 731,
		"Ludicolo": 200,
		"Luvdisc": 53,
		"Machamp": 303,
		"Machoke": 104,
		"Machop": 31,
		"Magby": 128,
		"Magcargo": 161,
		"Magikarp": 1,
		"Magmar": 450,
		"Magnemite": 6,
		"Magneton": 78,
		"Makuhita": 86,
		"Manectric": 200,
		"Mankey": 3,
		"Mantine": 400,
		"Mareep": 43,
		"Maril": 43,
		"Marowak": 171,
		"Marshtomp": 121,
		"Masquerain": 226,
		"Mawile": 465,
		"Medicham": 200,
		"Meditite": 52,
		"Meganium": 259,
		"Meowth": 3,
		"Metang": 718,
		"Metapod": 3,
		"Mightyena": 259,
		"Miltank": 532,
		"Minun": 69,
		"Misdreavus": 800,
		"Mr. Mime": 665,
		"Mudkip": 43,
		"Muk": 171,
		"Murkrow": 148,
		"Natu": 43,
		"Nidoking": 200,
		"Nidoqueen": 200,
		"Nidoran Female": 3,
		"Nidoran Male": 3,
		"Nidorina": 33,
		"Nidorino": 33,
		"Nincada": 5,
		"Ninetales": 165,
		"Noctowl": 223,
		"Numel": 52,
		"Nuzleaf": 121,
		"Octillery": 148,
		"Oddish": 1,
		"Onix": 86,
		"Paras": 1,
		"Parasect": 113,
		"Pelipper": 200,
		"Persian": 43,
		"Phanpy": 43,
		"Pichu": 43,
		"Pidgeot": 200,
		"Pidgeotto": 43,
		"Pidgey": 0.5,
		"Pikachu": 121,
		"Piloswine": 161,
		"Pineco": 5,
		"Pinsir": 598,
		"Plusle": 69,
		"Politoed": 121,
		"Poliwag": 2,
		"Poliwhirl": 43,
		"Poliwrath": 190,
		"Ponyta": 23,
		"Poochyena": 43,
		"Primeape": 113,
		"Psyduck": 23,
		"Pupitar": 465,
		"Quagsire": 173,
		"Quilava": 121,
		"Qwilfish": 148,
		"Raichu": 200,
		"Ralts": 47,
		"Rapidash": 156,
		"Raticate": 30,
		"Rattata": 0.5,
		"Relicanth": 126,
		"Remoraid": 4,
		"Rhydon": 190,
		"Rhyhorn": 43,
		"Sableye": 321,
		"Sandshrew": 16,
		"Sandslash": 126,
		"Sceptile": 259,
		"Scizor": 800,
		"Scyther": 465,
		"Seadra": 86,
		"Seaking": 43,
		"Sealeo": 161,
		"Seedot": 43,
		"Seel": 31,
		"Sentret": 5,
		"Seviper": 500,
		"Sharpedo": 233,
		"Shelgon": 718,
		"Shellder": 4,
		"Shiftry": 200,
		"Shiny Abra": 50,
		"Shiny Alakazam": 450,
		"Shiny Ampharos": 325,
		"Shiny Arcanine": 450,
		"Shiny Ariados": 700,
		"Shiny Beedrill": 65,
		"Shiny Blastoise": 325,
		"Shiny Butterfree": 65,
		"Shiny Charizard": 325,
		"Shiny Crobat": 325,
		"Shiny Cubone": 78,
		"Shiny Dodrio":700,
		"Shiny Dragonair":150,
		"Shiny Dragonite":425,
		"Shiny Dratini":95,
		"Shiny Electabuzz":425,
		"Shiny Electrode":150,
		"Shiny Espeon":700,
		"Shiny Farfetch'd":175,
		"Shiny Feraligatr":325,
		"Shiny Gengar":325,
		"Shiny Giant Magikarp":150,
		"Shiny Golbat":110,
		"Shiny Grimer":65,
		"Shiny Growlithe":150,
		"Shiny Gyarados":425,
		"Shiny Horsea":58,
		"Shiny Jynx":425,
		"Shiny Kingler":230,
		"Shiny Krabby":35,
		"Shiny Lanturn":170,
		"Shiny Larvitar":75,
		"Shiny Machamp":325,
		"Shiny Magcargo":246,
		"Shiny Magikarp":56,
		"Shiny Magmar":425,
		"Shiny Magneton":700,
		"Shiny Mantine":225,
		"Shiny Marowak":550,
		"Shiny Meganium":325,
		"Shiny Mr. Mime":425,
		"Shiny Muk":220,
		"Shiny Ninetales":700,
		"Shiny Oddish":65,
		"Shiny Onix":700,
		"Shiny Paras":65,
		"Shiny Parasect":150,
		"Shiny Pidgeot":280,
		"Shiny Pinsir":425,
		"Shiny Politoed":700,
		"Shiny Pupitar":180,
		"Shiny Raichu":325,
		"Shiny Raticate":150,
		"Shiny Rattata":65,
		"Shiny Rhydon":700,
		"Shiny Sandslash":170,
		"Shiny Scyther":550,
		"Shiny Seadra":85,
		"Shiny Skarmory":425,
		"Shiny Snorlax":600,
		"Shiny Stantler":700,
		"Shiny Steelix":425,
		"Shiny Sudowoodo":425,
		"Shiny Tangela":250,
		"Shiny Tauros":325,
		"Shiny Tentacool":35,
		"Shiny Tentacruel":325,
		"Shiny Typhlosion":325,
		"Shiny Tyranitar":425,
		"Shiny Umbreon":700,
		"Shiny Venomoth":250,
		"Shiny Venonat":60,
		"Shiny Venusaur":325,
		"Shiny Voltorb":35,
		"Shiny Weezing":170,
		"Shiny Xatu":190,
		"Shiny Zubat":65,
		"Shroomish":66,
		"Shuckle":42,
		"Shuppet":52,
		"Castform Ice":800,
		"Silcoon":66,
		"Skarmory":400,
		"Skiploom":33,
		"Skitty":47,
		"Slakoth":121,
		"Slowbro":126,
		"Slowking":750,
		"Slowpoke":6,
		"Slugma":16,
		"Smeargle 1":280,
		"Smeargle 2":280,
		"Smeargle 3":280,
		"Smeargle 4":280,
		"Smeargle 5":280,
		"Smeargle 6":280,
		"Smeargle 7":280,
		"Smeargle 8":280,
		"Smeargle":280,
		"Smoochum":69,
		"Sneasel":148,
		"Snorlax":600,
		"Snorunt":52,
		"Snubbull":38,
		"Spearow":1,
		"Spheal":86,
		"Spinarak":5,
		"Spinda":47,
		"Spoink":52,
		"Squirtle":43,
		"Stantler":148,
		"Starmie":43,
		"Staryu":6,
		"Steelix":600,
		"Sudowoodo":525,
		"Sunflora":80,
		"Sunkern":2,
		"Surskit":47,
		"Swablu":79,
		"Swalot":800,
		"Swampert":259,
		"Swellow":200,
		"Swinub":16,
		"Taillow":43,
		"Tangela":148,
		"Tauros":78,
		"Teddiursa":94,
		"Tentacool":3,
		"Tentacruel":217,
		"Togepi":217,
		"Togetic":363,
		"Torchic":43,
		"Torkoal":465,
		"Totodile":43,
		"Trapinch":43,
		"Treecko":43,
		"Tropius":800,
		"Typhlosion":259,
		"Tyranitar":532,
		"Umbreon":259,
		"Ursaring":525,
		"Vaporeon":259,
		"Venomoth":113,
		"Venonat":23,
		"Venusaur":200,
		"Vibrava":121,
		"Victreebel":172,
		"Vigoroth":200,
		"Vileplume":172,
		"Volbeat":66,
		"Voltorb":5,
		"Vulpix":16,
		"Walrein":665,
		"Wartortle":121,
		"Weedle":0.5,
		"Weepinbell":33,
		"Weezing":43,
		"Whiscash":113,
		"Whismur":43,
		"Wigglytuff":260,
		"Wingull":47,
		"Wobbuffet":800,
		"Wooper":31,
		"Wurmple":20,
		"Wynaut":65,
		"Xatu":190,
		"Yanma":118,
		"Zangoose":319,
		"Zigzagoon":66,
		"Zubat":2,
    };
    const searchButton = document.getElementById("searchButton");
    const pokemonInput = document.getElementById("pokemonInput");
    const resultContainer = document.getElementById("resultContainer");
    const averageSpan = document.getElementById("average");
    const message = document.getElementById("message");

    searchButton.addEventListener("click", () => {
      const pokemonName = pokemonInput.value.toLowerCase();
      const lowercasePokemonData = Object.keys(pokemonData).reduce((acc, key) => {
        acc[key.toLowerCase()] = pokemonData[key];
        return acc;
      }, {});

      if (lowercasePokemonData.hasOwnProperty(pokemonName)) {
        if (pokemonName.startsWith('shiny')) {
			averageSpan.textContent = "Este pokémon Shiny, o sistema de média não se aplica ao sistema de média!";
          message.textContent = "";
        } else {
          const average = lowercasePokemonData[pokemonName];
          averageSpan.textContent = average;
          message.textContent = "";
        }
        resultContainer.style.display = "block";
      } else {
        resultContainer.style.display = "none";
      }
    });
  </script>
</body>
</html>

<?php include 'layout/overall/footer.php'; ?>



