<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

//comprobar si se ha hecho login
comprobarLogin();

//volver atras
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
    header("Location: ./crearPersonaje2.php");
    exit();
}
//cargar el personaje y datos importantes
$personaje = $_SESSION["personaje"];
$clase = getClass(getCon(), $personaje->clase)[0];
$progresion = getClassLevelProgression(getCon(), $personaje->clase, 1)[0];
if (!isset($personaje->competenciasClase)) {
    $personaje->competenciasClase = [];
}
$error = "";

//obtener las competencias
$competenciasClase = getProfClass(getCon(), $personaje->clase, 1);

//si se ha pulsado el boton para avanzar
if (isset($_POST['siguiente'])) {
    //validar las competencias
    if (isset($_POST['checkCompetencias']) && count($_POST['checkCompetencias']) == $clase->prof_cuantity) {
        $competencias = [];
        foreach ($_POST['checkCompetencias'] as $competencia) {
            $competencias[] = $competencia;
        }
        foreach ($competenciasClase as $competencia) {
            if ($competencia->prof_type != "skill") {
                $competencias[] = $competencia->prof_id;
            }
        }
        $personaje->competenciasClase = $competencias;
    } else {
        $error .= "El " . $clase->class_name . " tiene " . $clase->prof_cuantity . " competencias<br>";
    }

    //validar pericia
    if (isset($_POST['pericias'])) {
        if (count($_POST['pericias']) == 2) {
            $pericias = [];
            foreach ($_POST['pericias'] as $pericia) {
                $pericias[] = $pericia;
            }
            $personaje->pericias = $pericias;
        } else {
            $error .= "El " . $clase->class_name . " tiene 2 pericias<br>";
        }
    }

    //validar los conjuros
    if ($clase->class_spellcaster == 1) {
        if ($progresion->cantrips_known > 0) {
            if (isset($_POST['Trucos']) && $progresion->cantrips_known == count($_POST['Trucos'])) {
                $personaje->trucos = $_POST['Trucos'];
            } else {
                $error .= "El " . $clase->class_name . " tiene " . $progresion->cantrips_known . " trucos conocidos<br>";
            }
        }
        if (isset($_POST['Nivel1']) && $progresion->spells_known == count($_POST['Nivel1'])) {
            $personaje->nivel1 = $_POST['Nivel1'];
        } else {
            $error .= "El " . $clase->class_name . " tiene " . $progresion->spells_known . " conjuros conocidos<br>";
        }
    }
    //validar las maestrias
    if ($clase->mastery_count > 0) {
        if (isset($_POST['maestrias']) && count($_POST['maestrias']) == $clase->mastery_count) {
            $personaje->maestrias = $_POST['maestrias'];
        } else {
            $error .= "El " . $clase->class_name . " tiene " . $clase->mastery_count . " maestrias conocidas<br>";
        }
    }
    $_SESSION['personaje'] = $personaje;
    if ($error == "") {
        //guardar la vida en el personaje
        $personaje->pg += intval(substr($clase->class_hpdice, 1)) + (obtenerModificador($personaje->constitucion));
        $_SESSION['personaje'] = $personaje;
        header("Location: ./crearPersonaje4.php");
        exit();
    }
}

//obtener los traits de la clase
$traitsClase = getTraitClass(getCon(), $personaje->clase, 1);

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <?php
        if ($error != "") {
            echo "<p style='color: red'>$error</p>";
        }
        ?>
        <form action="" method="post">
            <h2 class="centrado"><?php echo $clase->class_name; ?></h2>
            <hr class="ocupaTodo">
            <!-- Informacion sobre las tiradas se salvacion en las que eres competente -->
            <h3 class="centrado">Salvaciones</h3>
            <div class="grid-2">
                <h4 class="centrado"><?php echo getAbility(getCon(), $clase->safe1_ability_id)[0]->ability_name ?></h4>
                <h4 class="centrado"><?php echo getAbility(getCon(), $clase->safe2_ability_id)[0]->ability_name ?></h4>
            </div>
            <hr class="ocupaTodo">
            <!-- Informacion sobre los rasgos de la clase -->
            <h3 class="centrado">Rasgos de la clase</h3>
            <ul>
                <?php
                foreach ($traitsClase as $trait) {
                    echo "<li><b>" . $trait->trait_name . ": </b>" . $trait->trait_desc . "</li>";
                }
                ?>
            </ul>
            <div class="gridResponsive">

                <?php
                mostrarCompetencias($competenciasClase, true, $personaje->competenciasClase, $clase->prof_cuantity);
                ?>
            </div>
            <?php
            //Si es lanzador de conjuros mostrar las tablas con los conjuros que puede aprender
            if ($clase->class_spellcaster) {
                echo "<hr class='ocupaTodo'>";
                echo "<h3>" . getAbility(getCon(), $clase->spellcasting_ability)[0]->ability_name .
                    " es tu aptitud de lanzamiento de conjuros</h3>";
                //cantrips
                if ($progresion->cantrips_known > 0) {
                    mostrarTablaSpells("Trucos", $clase->class_id, 0, $progresion->cantrips_known);
                }
                //nivel1
                mostrarTablaSpells("Nivel1", $clase->class_id, 1, $progresion->spells_known);
            }
            //si tiene maestrias de arma, mostrar una lista con todas las armas para que escoja las maestrias que quiera
            if ($clase->mastery_count > 0) {
                $armas = getItemWeapon(getCon());
                echo "<hr class='ocupaTodo'>";
                echo "<h3 class='centrado'>Maestrias</h3>";
                echo "<h4>Elige " . $clase->mastery_count . " maestrias</h4>";
                echo "<br>";
                echo "<div class='gridResponsive'>";
                foreach ($armas as $arma) {
                    echo "<div>";
                    $item = getItem(getCon(), $arma->item_id)[0];
                    $maestria = getMastery(getCon(), $arma->mastery_id)[0];
                    echo "<input type='checkbox' value='" . $arma->item_id . "' name='maestrias[]' " .
                        (isset($personaje->maestrias) && in_array($arma->item_id, $personaje->maestrias) ? "checked" : "") .
                        ">" . $item->item_name . " (" . $maestria->mastery_name . ")</input>";
                    echo "</div>";
                }
                echo "</div>";
            }
            ?>
            <?php
            //si tiene pericia
            if ($clase->class_id == 9) {
                echo "<hr class='ocupaTodo'>";
                echo "<h3>Pericias</h3>";
                echo "<h4>Elige 2 pericias (para que aparezcan las pericias, primero tienes que ser competente en esa habilidad)</h4>";
                echo "<div id='pericias'></div>";
            }
            ?>
            <hr class="ocupaTodo">
            <div class="centrado">
                <input type="submit" name="anterior" value="Anterior">
                <input type="submit" name="siguiente" value="Siguiente">
            </div>
        </form>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        cargarPericias("chkHabilidades", "pericias");
    });
</script>
</body>

</html>