<?php
require_once "../utility/utils.php";

$personaje = $_SESSION["personaje"];

if (isset($_GET['subraza'])) {
    $competenciasRaza = getProfRace(getCon(), $personaje->raza);
    $subrazaElegida = $_GET['subraza'];
    $traitsSubraza = getTraitRace(getCon(), $personaje->raza);
    if ($subrazaElegida != -1) {
        $traitsSubraza = getTraitRace(getCon(), $personaje->raza, $subrazaElegida);
    }
    echo "<ul style='margin-top: 0'>";
    foreach ($traitsSubraza as $traitSubraza) {
        echo "<li><b>" . $traitSubraza->trait_name . ": </b>" . $traitSubraza->trait_desc . "</li>";
    }
    echo "</ul>";
    echo "<div class='gridResponsive'>";
    mostrarCompetencias($competenciasRaza);
    echo "</div>";
    echo "<ul>";
    echo "</ul>";
    $competenciasHabilidades = array_filter($competenciasRaza, function ($competencia) {
        return $competencia->prof_type == "skill";
    });
    $personaje->competenciasRaza=[];
    if(count($competenciasHabilidades)>0){
        $competenciasRazaSkills=[];
        foreach ($competenciasHabilidades as $skill) {
            $competenciasRazaSkills[]=$skill->prof_id;
        }
        $personaje->competenciasRaza=$competenciasRazaSkills;
    }
}
