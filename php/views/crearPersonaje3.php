<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->subraza)) {
    header("Location: ./crearPersonaje2.php");
    exit();
}
$personaje = $_SESSION["personaje"];
$clase = getClass(getCon(), $personaje->clase);
if (!isset($personaje->competenciasClase)) {
    $personaje->competenciasClase = [];
}

if (isset($_POST['siguiente'])) {
    //TODO arreglar cuando se sepa cuantas competencias se pueden seleccionar y los spells
    if (isset($_POST['checkCompetencias'])) {
        $personaje->competenciasClase = $_POST['checkCompetencias'];
    }
    if (isset($_POST['Cantrips'])) {
        $personaje->cantrips = $_POST['Cantrips'];
    }
    if (isset($_POST['Nivel1'])) {
        $personaje->nivel1 = $_POST['Nivel1'];
    }
    $_SESSION['personaje'] = $personaje;
    if (isset($_POST['checkCompetencias']) && ($clase[0]->class_spellcaster == 0 || $clase[0]->class_spellcaster == 1 &&
        isset($_POST['Cantrips']) && isset($_POST['Nivel1']))) {

        $personaje->pg = intval(substr($clase[0]->class_hpdice, 1)) + (($personaje->constitucion - 10) / 2);
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
        <form action="" method="post">
            <h2><?php echo $clase[0]->class_name; ?></h2>
            <h3>Rasgos de la clase</h3>
            <ul>
                <?php
                foreach ($traitsClase as $trait) {
                    echo "<li><b>" . $trait->trait_name . ": </b>" . $trait->trait_desc . "</li>";
                }
                ?>
            </ul>
            <div class="gridResponsive">

                <?php
                //TODO acabar con los checkbox
                mostrarCompetencias($competenciasClase, true, $personaje->competenciasClase);
                ?>
            </div>
            <?php
            if ($clase[0]->class_spellcaster == 1) {
                echo "<hr class='ocupaTodo'>";
                //TODO acabar cuando se sepa la cantidad de spells de cada nivel que se puede elegir
                //cantrips
                mostrarTablaSpells("Cantrips", $clase[0]->class_id, 0);
                //nivel1
                mostrarTablaSpells("Nivel1", $clase[0]->class_id, 1);
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