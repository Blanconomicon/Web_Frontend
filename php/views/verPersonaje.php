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
$modificadores = [$modFuerza, $modDestreza, $modConstitucion, $modInteligencia, $modSabiduria, $modCarisma];

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
        <div class="dnd__stat-box">Velocidad <br> <?php echo $personaje->speed ?> pies / <?php echo ($personaje->speed * 0.3) ?> metros</div>
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
        <!-- HABILIDADES -->
        <div class="dnd__skills">
          <?php
          mostarListaHabilidades($modificadores, $personaje->proficiency_bonus, $personaje->character_id);
          ?>

        </div>

      </div>

      <!-- BLOQUES INFERIORES -->
      <!-- TODO meter los datos del personaje -->
      <div class="dnd__bottom">

        <div class="dnd__block">
          <h3 class="centrado">Equipo</h3>
          <div class="dnd__block-content">
            <div class='dnd__skill' style="border-width: 0.3em;"><span>Nombre</span><span class='dnd__skill-mod'>Cantidad</span></div>
            <?php
            $items=getCharacterInventory(getCon(),$personaje->character_id);
            foreach ($items as $item) {
              $itemCompleto=getItem(getCon(),$item->item_id)[0];
              echo "<div class='dnd__skill'><span>".$itemCompleto->item_name."</span><span class='dnd__skill-mod'>".$item->quantity."</span></div>";
            }
            ?>
            <!-- <p class="dnd__skill">objeto1</p> -->
          </div>
        </div>

        <div class="dnd__block">
          <h3 class="centrado">Rasgos</h3>
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
          <h3 class="centrado">Hechizos</h3>
          <div class="dnd__block-content">
            <?php
            $conjuros = getCharacterSpell(getCon(), $personaje->character_id);
            if (count($conjuros) > 0) {
              echo "<ul>";
              $url = basename($_SERVER['PHP_SELF']) . "?idPersonaje=" . $personaje->character_id;
              foreach ($conjuros as $conjuro) {
                $url .= '&descripcionSpell=' . $conjuro->spell_id;
                $spell = getSpell(getCon(), $conjuro->spell_id)[0];
                if ($spell->spell_level > 0) {
                  echo "<li><a href='" . $url . "'>" . $spell->spell_name . " - Nivel " . $spell->spell_level . "</a></li>";
                } else {
                  echo "<li><a href='" . $url . "'>" . $spell->spell_name . " - Truco</a></li>";
                }
                $url = basename($_SERVER['PHP_SELF']) . "?idPersonaje=" . $personaje->character_id;
                if (isset($_GET['descripcionSpell'])) {
                  if ($conjuro->spell_id == $_GET['descripcionSpell']) {
                    echo "<ul>";
                    echo "<li><b>Esculea: </b>" . getSpellSchool(getCon(), $spell->spell_school_id)[0]->spell_school_name . "</li>";
                    echo "<li><b>Ritual: </b>" . (($spell->spell_ritual) ? "Es ritual" : "No es ritual") . "</li>";
                    echo "<li><b>Tiempo de lanzamiento: </b>" . $spell->spell_cast_time . "</li>";
                    echo "<li><b>Distancia: </b>" . $spell->spell_range . "</li>";
                    echo "<li><b>Duracion: </b>" . $spell->spell_duration . "<li>";
                    echo "<li><b>Concentracion: </b>" . (($spell->spell_concentration) ? "Requiere concentracion" : "No requiere concentracion") . "</li>";
                    echo "<li><b>Descripcion: </b>" . $spell->spell_desc . "</li>";
                    if ($spell->spell_level > 0) {
                      if ($spell->spell_higher_level) {
                        echo "<li><b>A niveles superiores: </b>" . $spell->spell_higher_level . "</li>";
                      } else {
                        echo "<li><b>A niveles superiores: </b>Lanzar este hechizo a niveles superiores no otorga ninguna ventaja adicional</li>";
                      }
                    }
                    echo "</ul>";
                  }
                }
              }
              echo "</ul>";
            } else {
              echo "<p>No tienes conjuros</p>";
            }
            ?>
          </div>
        </div>

      </div>

    </section>
  </main>
</body>

</html>