<?php
require_once "../utility/utils.php";

$personaje = $_SESSION["personaje"];

if (isset($_GET['subraza'])) {
    $competenciasRaza = getProfRace(getCon(), $personaje->raza);
    $subrazaElegida = $_GET['subraza'];
    $traitsSubraza = getTraitRace(getCon(), $personaje->raza, $subrazaElegida);
    if ($subrazaElegida == -1) {
        $traitsSubraza = getTraitRace(getCon(), $personaje->raza);
    }
    echo "<ul>";
    foreach ($traitsSubraza as $traitSubraza) {
        echo "<li><b>" . $traitSubraza->trait_name . ":</b>" . $traitSubraza->trait_desc . "</li>";
    }
    echo "</ul>";
    echo "<div class='gridResponsive'>";
    mostrarCompetencias($competenciasRaza);
    echo "</div>";
    echo "<ul>";
    // foreach ($competenciasRaza as $competencia) {
    //     echo "<li>" . $competencia->prof_type . "</li>";
    // }
    echo "</ul>";
}
