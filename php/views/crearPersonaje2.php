<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

//comprobar si se ha hecho login
comprobarLogin();

//volver atras
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"])) {
    header("Location: ./crearPersonaje.php");
    exit();
}
//cargar el personaje
$personaje = $_SESSION["personaje"];

//si se ha pulsado el boton para avanzar
if (isset($_POST['siguiente'])) {
    //cargar la subraza
    $personaje->subraza = $_POST["subraza"];
    if (isset($_POST['dote'])) {
        $personaje->dotes[] = $_POST['dote'];
    }
    //calcular la iniciativa
    $iniciativa = obtenerModificador($personaje->destreza);
    if (in_array(1, $personaje->dotes)) {
        $iniciativa += 2;
    }
    $personaje->iniciativa = $iniciativa;
    $personaje->tamanio = $_POST["tamanio"];
    $_SESSION['personaje'] = $personaje;
    header("Location: ./crearPersonaje3.php");
    exit();
}

//obtener informacion raza
$raza = getRace(getCon(), $personaje->raza)[0];
$tamanios = getSize(getCon(), $raza->size_id);
$subrazas = getSubrace(getCon(), $personaje->raza);

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $raza->race_name ?></h2>
            <?php
            //mostrar select de subraza si hay subrazas
            if (count($subrazas) > 0) {
            ?>
                <select name="subraza" id="subraza">
                    <?php
                    foreach ($subrazas as $subraza) {
                        echo "<option value='$subraza->subrace_id'>$subraza->subrace_name</option>";
                    }
                    ?>
                </select>
            <?php
            } else {
                //dar valor de -1 a la subraza si no tiene
                echo "<input type='hidden' name='subraza' value=-1>";
            }
            ?>
            <br>
            <select name="tamanio" id="tamanio">
                <?php
                echo "<option value='" . $tamanios[0]->size_id . "'>" . $tamanios[0]->size_name . "</option>";
                //comprobar si puede ser de 2 tamanios
                if ($tamanios[0]->size_id == 3 && $raza->race_name != "Enano") {
                    echo "<option value='2'>Pequeño</option>";
                }
                ?>
            </select>
            <br>
            <hr class="ocupaTodo">
            <div class="ocupaTodo" style="width: 80%;">
                <h3 class="centrado">Rasgos de la raza</h3>
                <ul style="margin-bottom: 0;">
                    <?php
                    //mostrar la esperanza de vida y la velocidad
                    echo "<li><b>Longevidad: </b>" . $raza->race_age . " años</li>";
                    echo "<li><b>Velocidad: </b>" . $raza->race_speed . " pies / " . ($raza->race_speed * 0.3) . " metros</li>";
                    ?>
                </ul>
                <!-- div cuyo contenido cambiara para mostrar la informacion de la raza y subraza -->
                <div id="traitsSubraza">
                </div>
                <?php
                //si es humano dar una dote adicional
                if ($raza->race_id == 1) {
                    echo "<h3 class='centrado'>Dote adicional</h3>";
                    $dotes = getFeat(getCon());
                    echo "<select name='dote' id='dote'>";
                    foreach ($dotes as $dote) {
                        echo "<option value='" . $dote->feat_id . "' " . (in_array($dote->feat_id, $personaje->dotes) ? "disabled" : "") . ">" . $dote->feat_name . "</option>";
                    }
                    echo "</select>";
                }
                ?>
            </div>
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
        cargarDesdeSelect("subraza", "traitsSubraza", "<?php echo "../includes/peticiones.php";  ?>", "subraza");
    });
</script>
</body>

</html>