<?php
        require_once "../utility/utils.php";
        require_once "../utility/conexion.php";

        comprobarLogin();
        if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
            header("Location: ./crearPersonaje2.php");
            exit();
        }
        $personaje = $_SESSION["personaje"];
        $clase = getClass(getCon(), $personaje->clase)[0];
        $progresion = getClassLevelProgression(getCon(), $personaje->clase, 1)[0];
        if (!isset($personaje->competenciasClase)) {
            $personaje->competenciasClase = [];
        }
        $error = "";
        if (isset($_POST['siguiente'])) {
            if (isset($_POST['checkCompetencias']) && count($_POST['checkCompetencias']) == $clase->prof_cuantity) {
                $personaje->competenciasClase = $_POST['checkCompetencias'];
            } else {
                $error .= "El " . $clase->class_name . " tiene " . $clase->prof_cuantity . " competencias<br>";
            }
            if ($clase->class_spellcaster == 1) {
                if (isset($_POST['Trucos']) && $progresion->cantrips_known == count($_POST['Trucos'])) {
                    $personaje->trucos = $_POST['Trucos'];
                } else {
                    $error .= "El " . $clase->class_name . " tiene " . $progresion->cantrips_known . " trucos conocidos<br>";
                }
                if (isset($_POST['Nivel1']) && $progresion->spells_known == count($_POST['Nivel1'])) {
                    $personaje->nivel1 = $_POST['Nivel1'];
                } else {
                    $error .= "El " . $clase->class_name . " tiene " . $progresion->spells_known . " hechizos conocidos<br>";
                }
            }
            $_SESSION['personaje'] = $personaje;
            if ($error == "") {
                $personaje->pg = intval(substr($clase->class_hpdice, 1)) + (($personaje->constitucion - 10) / 2);
                $_SESSION['personaje'] = $personaje;
                header("Location: ./crearPersonaje4.php");
                exit();
            }
        }

        $traitsClase = getTraitClass(getCon(), $personaje->clase, 1);
        $competenciasClase = getProfClass(getCon(), $personaje->clase, 1);

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
            <h3 class="centrado">Salvaciones</h3>
            <div class="grid-2">
                <h4 class="centrado"><?php echo getAbility(getCon(),$clase->safe1_ability_id )[0]->ability_name ?></h4>
                <h4 class="centrado"><?php echo getAbility(getCon(),$clase->safe2_ability_id )[0]->ability_name ?></h4>
            </div>
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
            if ($clase->class_spellcaster) {
                echo "<hr class='ocupaTodo'>";
                echo "<h3>".getAbility(getCon(),$clase->spellcasting_ability)[0]->ability_name." es tu aptitud de lanzamiento de conjuros</h3>";
                //cantrips
                mostrarTablaSpells("Trucos", $clase->class_id, 0,$progresion->cantrips_known);
                //nivel1
                mostrarTablaSpells("Nivel1", $clase->class_id, 1,$progresion->spells_known);
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
</body>

</html>