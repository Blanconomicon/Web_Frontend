<?php
require_once "../utility/utils.php";

$personaje = $_SESSION["personaje"];

//elegir subraza
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
    $competenciasHabilidades = $competenciasRaza;
    $personaje->competenciasRaza = [];
    if (count($competenciasHabilidades) > 0) {
        $competenciasRazaSkills = [];
        foreach ($competenciasHabilidades as $skill) {
            $competenciasRazaSkills[] = $skill->prof_id;
        }
        $personaje->competenciasRaza = $competenciasRazaSkills;
    }
}

//elegir trasfondo
if (isset($_GET['trasfondo'])) {
    $trasfondo = $_GET['trasfondo'];
    $habilidadesTrasfondo = getBackgroundAbility(getCon(), $trasfondo);
    $infoTrasfondo = getBackground(getCon(), $trasfondo);
    echo "<h3 class='centrado'>+1 a las caracteristicas seleccionadas</h3>";
    echo "<h4 class='centrado'>Ten en cuenta que como mucho puedes darle un +2</h4>";
    echo "<br>";
    echo "<div class='gridResponsive'>";
    for ($i = 0; $i < count($habilidadesTrasfondo); $i++) {
        echo "<select name='habilidad" . ($i + 1) . "' id='habilidad" . ($i + 1) . "' onchange='fijarValorTotal()'>";
        foreach ($habilidadesTrasfondo as $habilidad) {
            echo "<option value='" . $habilidad->ability_id . "' " . ((isset($personaje) && ($personaje->{"habilidad" . ($i + 1)} == $habilidad->ability_id)) ? "selected" : "") . ">" . $habilidad->ability_name . "</option>";
        }
        echo "</select>";
    }
    echo "</div>";
    echo "<br>";
    $idDote = getBackgroundFeat(getCon(), $trasfondo)[0]->feat_id;
    $dote = getFeat(getCon(), $idDote)[0];
    echo "<h3 class='centrado'>" . $dote->feat_name . "</h3>";
    echo "<p>" . $dote->feat_desc . "</p>";
}

//elegir items del trasfondo
if (isset($_GET['itemsTrasfondo'])) {
    $seleccion = $_GET['itemsTrasfondo'];
    $trasfondo = getBackground(getCon(), $personaje->trasfondo)[0];
    $equipoTrasfondo = getBundle(getCon(), $trasfondo->bundle_id)[0];
    $itemsTrasfondo = getBundleItems(getCon(), $trasfondo->bundle_id);
    if ($seleccion == "items") {
        echo "<ul>";
        foreach ($itemsTrasfondo as $item) {
            echo "<li>";
            echo $item->item_name . " (" . $item->cantidad . ")";
            echo "</li>";
        }
        echo "</ul>";
    } else {
        //oro
        echo "<p>" . $equipoTrasfondo->bundle_price . " po</p>";
    }
}

//elegir items de la clase
if (isset($_GET['itemsClase'])) {
    $seleccion = $_GET['itemsClase'];
    $clase = getClass(getCon(), $personaje->clase)[0];
    $claseBundle = getClassBundle(getCon(), $personaje->clase);
    $precio = getBundle(getCon(), $claseBundle[0]->bundle_id)[0];
    $bundleEquipoExtra = getBundle(getCon(), $clase->class_bundle_id)[0];
    if ($seleccion == "oro") {
        echo "<p>" . $precio->bundle_price . " po</p>";
    } else {
        $items = getBundleItems(getCon(), $bundleEquipoExtra->bundle_id);
        if ($seleccion == "items") {
            $itemsClase = getBundleItems(getCon(), $claseBundle[0]->bundle_id);
            foreach ($itemsClase as $item) {
                foreach ($items as $key => $existingItem) {
                    if ($existingItem->item_id === $item->item_id) {
                        $item->cantidad += $existingItem->cantidad;
                        unset($items[$key]);
                        break;
                    }
                }
                $items[] = $item;
            }
            echo "<ul>";
            foreach ($items as $item) {
                echo "<li>";
                echo $item->item_name . " (" . $item->cantidad . ")";
                echo "</li>";
            }
            echo "<li>" . $precio->extra_gp . " po</li>";
            echo "</ul>";
        } else {
            //items2 solo en caso del guerrero
            $precio = getBundle(getCon(), $claseBundle[1]->bundle_id)[0];
            $itemsClase = getBundleItems(getCon(), $claseBundle[1]->bundle_id);
            foreach ($itemsClase as $item) {
                foreach ($items as $key => $existingItem) {
                    if ($existingItem->item_id === $item->item_id) {
                        $item->cantidad += $existingItem->cantidad;
                        unset($items[$key]);
                        break;
                    }
                }
                $items[] = $item;
            }
            echo "<ul>";
            foreach ($items as $item) {
                echo "<li>";
                echo $item->item_name . " (" . $item->cantidad . ")";
                echo "</li>";
            }
            echo "<li>" . $precio->extra_gp . " po</li>";
            echo "</ul>";
        }
    }
}
