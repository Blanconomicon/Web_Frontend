<?php
require_once "../utility/utils.php";

comprobarLogin();
if (!isset($_GET['idPersonaje'])) {
  header("Location: ./personajes.php");
  exit();
}

$personaje = getCharacter(getCon(), $_SESSION['user'][0]->user_nick, $_GET['idPersonaje'])[0];
$clase = getClass(getCon(), $personaje->class_id)[0];
$claseNombre = $clase->class_name;
$dadoDeGolpe = $clase->class_hpdice;
$raza = getRace(getCon(), $personaje->race_id)[0]->race_name;
if ($personaje->subrace_id != -1) {
  $subraza = getSubrace(getCon(), $personaje->race_id, $personaje->subrace_id)[0]->subrace_name;
}
$trasfondo = getBackground(getCon(), $personaje->background_id)[0]->background_name;
$modFuerza = obtenerModificador($personaje->strength);
$modDestreza = obtenerModificador($personaje->dexterity);
$modConstitucion = obtenerModificador($personaje->constitution);
$modInteligencia = obtenerModificador($personaje->intelligence);
$modSabiduria = obtenerModificador($personaje->wisdom);
$modCarisma = obtenerModificador($personaje->charisma);
$modificadores=[$modFuerza,$modDestreza,$modConstitucion,$modInteligencia,$modSabiduria,$modCarisma];

$traitsClase = getTraitClass(getCon(), $personaje->class_id, $personaje->character_level);
$traitsSubraza = getTraitRace(getCon(), $personaje->race_id);
if ($personaje->subrace_id != -1) {
  $traitsSubraza = getTraitRace(getCon(), $personaje->race_id, $personaje->subrace_id);
}
?><html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="author" content="Aketza Gonzalez Rey">
  <meta name="author" content="Daniel Alvarez Burgo">
  <meta name="description" content="Pagina principal en la cual, se muestra una breve descripcion de que es Blanconomicon">

  <link rel="stylesheet" href="../../css/verPersonaje.css">
  <link rel="icon" href="../../src/img/logo1.png" type="image/x-icon">
  <?php
  echo "<title>Blanconomicon | " . ucfirst(substr(basename($_SERVER['PHP_SELF']), 0, strlen(basename($_SERVER['PHP_SELF'])) - 4))
    . "</title>"
  ?>
</head>

<body>
  <main>
    <section class="dnd__sheet">
      <!-- CABECERA -->
      <div class="dnd__header">
        <div class="dnd__title"><?php echo $personaje->character_name ?></div>
        <div class="dnd__text">
          <?php
          echo $claseNombre;
          if ($personaje->subclass_id) {
            echo "<span class='dnd__muted'> - Subclase</span>";
          }
          ?>
        </div>
        <div class="dnd__text">
          <?php
          echo $raza;
          if ($personaje->subrace_id != -1) {
            echo "<span class='dnd__muted'> - " . $subraza . "</span>";
          }
          ?>
        </div>
        <div class="dnd__text"><?php echo $trasfondo ?></div>
      </div>

      <!-- STATS PRINCIPALES -->
      <div class="dnd__stats">
        <div class="dnd__stat-box">CA <br> <?php echo $personaje->armor_class ?></div>
        <div class="dnd__stat-box">Iniciativa <br> <?php echo $personaje->initiative ?></div>
        <!--Inspiraciones
        REVISAR TABLA CHARACTER-->
        <div class="dnd__stat-box">PG <?php echo $personaje->current_hp . "/" . $personaje->max_hp ?> <br> Dados de golpe
          <?php echo $personaje->character_level . "" . $dadoDeGolpe ?></div>
        <div class="dnd__stat-box">Velocidad <br> <?php echo $personaje->speed ?></div>
        <div class="dnd__stat-box">Bonif. competencia <br> <?php echo $personaje->proficiency_bonus ?></div>
      </div>

      <!-- ATRIBUTOS + HABILIDADES -->
      <div class="dnd__columns">
        <!-- ATRIBUTOS -->
        <div class="dnd__attributes">

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Fuerza</div>
            <div class="dnd__attr-mod"><?php echo $modFuerza ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->strength ?></div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Destreza</div>
            <div class="dnd__attr-mod"><?php echo $modDestreza ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->dexterity ?></div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Constitución</div>
            <div class="dnd__attr-mod"><?php echo $modConstitucion ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->constitution ?></div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Inteligencia</div>
            <div class="dnd__attr-mod"><?php echo $modInteligencia ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->intelligence ?></div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Sabiduría</div>
            <div class="dnd__attr-mod"><?php echo $modSabiduria ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->wisdom ?></div>
          </div>

          <div class="dnd__attribute">
            <div class="dnd__attr-name">Carisma</div>
            <div class="dnd__attr-mod"><?php echo $modCarisma ?></div>
            <div class="dnd__attr-score"><?php echo $personaje->charisma ?></div>
          </div>

        </div>
        <div class="dnd__skills">
          <h3>Tiradas de salvación</h3>
          <div class="dnd__skill"><span>Fuerza</span><span class="dnd__skill-mod">
              <?php
              $ts = $modFuerza;
              if ($clase->safe1_ability_id == 1 || $clase->safe2_ability_id == 1) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
          <div class="dnd__skill"><span>Destreza</span><span class="dnd__skill-mod">
              <?php
              $ts = $modDestreza;
              if ($clase->safe1_ability_id == 2 || $clase->safe2_ability_id == 2) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
          <div class="dnd__skill"><span>Constitución</span><span class="dnd__skill-mod">
              <?php
              $ts = $modConstitucion;
              if ($clase->safe1_ability_id == 3 || $clase->safe2_ability_id == 3) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
          <div class="dnd__skill"><span>Inteligencia</span><span class="dnd__skill-mod">
              <?php
              $ts = $modInteligencia;
              if ($clase->safe1_ability_id == 4 || $clase->safe2_ability_id == 4) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
          <div class="dnd__skill"><span>Sabiduria</span><span class="dnd__skill-mod">
              <?php
              $ts = $modSabiduria;
              if ($clase->safe1_ability_id == 5 || $clase->safe2_ability_id == 5) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
          <div class="dnd__skill"><span>Carisma</span><span class="dnd__skill-mod">
              <?php
              $ts = $modCarisma;
              if ($clase->safe1_ability_id == 6 || $clase->safe2_ability_id == 6) {
                $ts += $personaje->proficiency_bonus;
              }
              echo $ts
              ?>
            </span></div>
        </div>
        <!-- TODO hacer que vayan con las caracteristicas -->
        <!-- HABILIDADES -->
        <div class="dnd__skills">
          <!-- <div class="dnd__skill"><span>Acrobacias</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Arcanos</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Atletismo</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Engaño</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Historia</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Interpretación</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Intimidación</span><span class="dnd__skill-mod">+4</span></div>
          <div class="dnd__skill"><span>Investigación</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Juego de manos</span><span class="dnd__skill-mod">+5</span></div>
          <div class="dnd__skill"><span>Medicina</span><span class="dnd__skill-mod">+1</span></div>
          <div class="dnd__skill"><span>Naturaleza</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Percepción</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Perspicacia</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Persuasión</span><span class="dnd__skill-mod">+6</span></div>
          <div class="dnd__skill"><span>Religión</span><span class="dnd__skill-mod">+2</span></div>
          <div class="dnd__skill"><span>Sigilo</span><span class="dnd__skill-mod">+3</span></div>
          <div class="dnd__skill"><span>Supervivencia</span><span class="dnd__skill-mod">+1</span></div> -->
          <?php
            mostarListaHabilidades($modificadores,$personaje->proficiency_bonus,$personaje->character_id);
          ?>

        </div>

      </div>

      <!-- BLOQUES INFERIORES -->
      <!-- TODO meter los datos del personaje -->
      <div class="dnd__bottom">

        <div class="dnd__block">
          <div class="dnd__block-title">Equipo</div>
          <div class="dnd__block-content">
            <ul>
              <li>objeto1</li>
              <li>objeto2</li>
              <li>objeto3</li>
            </ul>
          </div>
        </div>

        <div class="dnd__block">
          <div class="dnd__block-title">Rasgos</div>
          <div class="dnd__block-content">
            <ul>
              <?php
              foreach ($traitsSubraza as $trait) {
                echo "<li><b>" . $trait->trait_name . ": </b>" . $trait->trait_desc . "</li>";
              }
              foreach ($traitsClase as $trait) {
                echo "<li><b>" . $trait->trait_name . ": </b>" . $trait->trait_desc . "</li>";
              }
              ?>
            </ul>
          </div>
        </div>

        <div class="dnd__block">
          <div class="dnd__block-title">Hechizos</div>
          <div class="dnd__block-content">
            <ul>
              <li>spell1</li>
              <li>spell2</li>
              <li>spell3</li>
            </ul>
          </div>
        </div>

      </div>

    </section>
  </main>
</body>

</html>