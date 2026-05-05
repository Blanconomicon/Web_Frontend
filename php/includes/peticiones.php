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

if(isset($_GET['trasfondo'])){
    $trasfondo=$_GET['trasfondo'];
    $habilidadesTrasfondo=getBackgroundAbility(getCon(),$trasfondo);
    $infoTrasfondo=getBackground(getCon(),$trasfondo);
    echo "<h3 class='centrado'>+1 a las caracteristicas seleccionadas</h3>";
    echo "<h4 class='centrado'>Ten en cuenta que como mucho puedes darle un +2</h4>";
    echo "<br>";
    echo "<div class='gridResponsive'>";
    for ($i=0; $i < count($habilidadesTrasfondo); $i++)  {
        echo "<select name='habilidad".($i+1)."' id='habilidad".($i+1)."' onchange='fijarValorTotal()'>";
        foreach ($habilidadesTrasfondo as $habilidad) {
            echo "<option value='".$habilidad->ability_id."' ".((isset($personaje)&&($personaje->{"habilidad".($i+1)}==$habilidad->ability_id))?"selected":"").">".$habilidad->ability_name."</option>";
        }
        echo "</select>";
    }
    echo "</div>";
}
