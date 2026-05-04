<?php
require_once "../utility/utils.php";

$personaje = $_SESSION["personaje"];
$traitsRaza = getTraitRace(getCon(), $personaje->raza);
$competenciaRaza = getProfRace(getCon(), $personaje->raza);

if (isset($_GET['subraza'])) {
    $subrazaElegida = $_GET['subraza'];
    $traitsSubraza = getTraitRace(getCon(), $personaje->raza, $subrazaElegida);
    if ($subrazaElegida == -1) {
        $traitsSubraza = getTraitRace(getCon(), $personaje->raza);
    }
    foreach ($traitsSubraza as $traitSubraza) {
        echo "<li><b>" . $traitSubraza->trait_name . ":</b>" . $traitSubraza->trait_desc . "</li>";
    }
    foreach ($competenciaRaza as $competencia) {
        echo "<li><b>" . $competencia->prof_type . ":</b>" . $competencia->prof_name . "</li>";
    }
}
