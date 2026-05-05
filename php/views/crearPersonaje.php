<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
$error = "";
if (isset($_POST['siguiente'])) {

    if ($_POST['habilidad1'] == $_POST['habilidad2'] && $_POST['habilidad1'] == $_POST['habilidad3']) {
        $error = "No puedes darte todos los +1 a la misma habilidad";
    }


    $personaje = new stdClass();
    $personaje->nombre = $_POST["nombrePj"];
    $personaje->raza = $_POST["raza"];
    $personaje->clase = $_POST["clase"];
    $personaje->trasfondo = $_POST["trasfondo"];
    $personaje->fuerza = $_POST["selectFuerza"];
    $personaje->destreza = $_POST["selectDestreza"];
    $personaje->constitucion = $_POST["selectConstitucion"];
    $personaje->inteligencia = $_POST["selectInteligencia"];
    $personaje->sabiduria = $_POST["selectSabiduria"];
    $personaje->carisma = $_POST["selectCarisma"];
    $personaje->habilidad1 = $_POST["habilidad1"];
    $personaje->habilidad2 = $_POST["habilidad2"];
    $personaje->habilidad3 = $_POST["habilidad3"];
    switch ($personaje->clase) {
        case 1:
            //barbaro
            $personaje->ca = 10 + obtenerModificador($personaje->destreza) + obtenerModificador($personaje->constitucion);
            break;
        case 7:
            //monje
            $personaje->ca = 10 + obtenerModificador($personaje->destreza) + obtenerModificador($personaje->sabiduria);
            break;
        default:
            //otros
            $personaje->ca = 10 + obtenerModificador($personaje->destreza);
            break;
    }
    $_SESSION['personaje'] = $personaje;
    if ($error == "") {
        switch ($_POST['habilidad1']) {
            case 1:
                $personaje->fuerza++;
                break;
            case 2:
                $personaje->destreza++;
                break;
            case 3:
                $personaje->constitucion++;
                break;
            case 4:
                $personaje->inteligencia++;
                break;
            case 5:
                $personaje->sabiduria++;
                break;
            case 6:
                $personaje->carisma++;
                break;
        }
        switch ($_POST['habilidad2']) {
            case 1:
                $personaje->fuerza++;
                break;
            case 2:
                $personaje->destreza++;
                break;
            case 3:
                $personaje->constitucion++;
                break;
            case 4:
                $personaje->inteligencia++;
                break;
            case 5:
                $personaje->sabiduria++;
                break;
            case 6:
                $personaje->carisma++;
                break;
        }
        switch ($_POST['habilidad3']) {
            case 1:
                $personaje->fuerza++;
                break;
            case 2:
                $personaje->destreza++;
                break;
            case 3:
                $personaje->constitucion++;
                break;
            case 4:
                $personaje->inteligencia++;
                break;
            case 5:
                $personaje->sabiduria++;
                break;
            case 6:
                $personaje->carisma++;
                break;
        }
        header("Location: ./crearPersonaje2.php");
        exit();
    }
}
$personaje = null;
if (isset($_SESSION['personaje'])) {
    $personaje = $_SESSION['personaje'];
}
switch ($personaje->habilidad1) {
    case 1:
        $personaje->fuerza--;
        break;
    case 2:
        $personaje->destreza--;
        break;
    case 3:
        $personaje->constitucion--;
        break;
    case 4:
        $personaje->inteligencia--;
        break;
    case 5:
        $personaje->sabiduria--;
        break;
    case 6:
        $personaje->carisma--;
        break;
}
switch ($personaje->habilidad2) {
    case 1:
        $personaje->fuerza--;
        break;
    case 2:
        $personaje->destreza--;
        break;
    case 3:
        $personaje->constitucion--;
        break;
    case 4:
        $personaje->inteligencia--;
        break;
    case 5:
        $personaje->sabiduria--;
        break;
    case 6:
        $personaje->carisma--;
        break;
}
switch ($personaje->habilidad3) {
    case 1:
        $personaje->fuerza--;
        break;
    case 2:
        $personaje->destreza--;
        break;
    case 3:
        $personaje->constitucion--;
        break;
    case 4:
        $personaje->inteligencia--;
        break;
    case 5:
        $personaje->sabiduria--;
        break;
    case 6:
        $personaje->carisma--;
        break;
}

$razas = getRace(getCon());
$clases = getClass(getCon());
$trasfondos = getBackground(getCon());

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
            <table>
                <tr>
                    <td colspan="2">
                        <input class="ocupaTodo" type="text" name="nombrePj" id="nombrePj" placeholder="Nombre del personaje" required value=<?php echo ($personaje != null) ? $personaje->nombre : "" ?>>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select class="ocupaTodo" name="raza" id="raza">
                            <?php
                            foreach ($razas as $raza) {
                                $selected = ($personaje && $personaje->raza == $raza->race_id) ? "selected" : "";
                                echo "<option value='" . $raza->race_id . "' $selected>" . $raza->race_name . "</option>";
                            }
                            ?>
                        </select>
                    </td>
                    <td>
                        <select class="ocupaTodo" name="clase" id="clase">
                            <?php
                            foreach ($clases as $clase) {
                                $selected = ($personaje && $personaje->clase == $clase->class_id) ? "selected" : "";
                                echo "<option value='" . $clase->class_id . "' $selected>" . $clase->class_name . "</option>";
                            }
                            ?>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <select class="ocupaTodo" name="trasfondo" id="trasfondo">
                            <?php
                            foreach ($trasfondos as $trasfondo) {
                                $selected = ($personaje && $personaje->trasfondo == $trasfondo->background_id) ? "selected" : "";
                                echo "<option value='" . $trasfondo->background_id . "' $selected>" . $trasfondo->background_name . "</option>";
                            }
                            ?>
                        </select>
                        <br>
                        <br>
                        <div id="infoTrafondo">
                            <select name="habilidad1" id="habilidad1"></select>
                            <select name="habilidad2" id="habilidad2"></select>
                            <select name="habilidad3" id="habilidad3"></select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <h3 class="centrado">Compra de puntos</h3>
                        <p class="centrado"><b id="txtRestantes">27/27</b></p>
                        <div class="gridResponsive">
                            <div>
                                <h3 class="centrado">Fuerza</h3>
                                <select name="selectFuerza" id="selectFuerza">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->fuerza == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtFuerzaTotal">
                                            <?php echo (isset($personaje->fuerza)) ? $personaje->fuerza : "8" ?>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtFuerzaModificador"><?php echo (isset($personaje->fuerza)) ? obtenerModificador($personaje->fuerza) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <h3 class="centrado">Destreza</h3>
                                <select name="selectDestreza" id="selectDestreza">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->destreza == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtDestrezaTotal"><?php echo (isset($personaje->destreza)) ? $personaje->destreza : "8" ?></td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtDestrezaModificador"><?php echo (isset($personaje->destreza)) ? obtenerModificador($personaje->destreza) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <h3 class="centrado">Constitucion</h3>
                                <select name="selectConstitucion" id="selectConstitucion">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->constitucion == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtConstitucionTotal"><?php echo (isset($personaje->constitucion)) ? $personaje->constitucion : "8" ?></td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtConstitucionModificador"><?php echo (isset($personaje->constitucion)) ? obtenerModificador($personaje->constitucion) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <h3 class="centrado">Inteligencia</h3>
                                <select name="selectInteligencia" id="selectInteligencia">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->inteligencia == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtInteligenciaTotal"><?php echo (isset($personaje->inteligencia)) ? $personaje->inteligencia : "8" ?></td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtInteligenciaModificador"><?php echo (isset($personaje->inteligencia)) ? obtenerModificador($personaje->inteligencia) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <h3 class="centrado">Sabiduria</h3>
                                <select name="selectSabiduria" id="selectSabiduria">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->sabiduria == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtSabiduriaTotal"><?php echo (isset($personaje->sabiduria)) ? $personaje->sabiduria : "8" ?></td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtSabiduriaModificador"><?php echo (isset($personaje->sabiduria)) ? obtenerModificador($personaje->sabiduria) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <h3 class="centrado">Carisma</h3>
                                <select name="selectCarisma" id="selectCarisma">
                                    <?php
                                    for ($i = 8; $i <= 15; $i++) {
                                        $selected = ($personaje && $personaje->carisma == $i) ? "selected" : "";
                                        echo "<option value='$i' $selected>$i</option>";
                                    }
                                    ?>
                                </select>
                                <br>
                                <table>
                                    <tr>
                                        <th>Total</th>
                                        <td id="txtCarismaTotal"><?php echo (isset($personaje->carisma)) ? $personaje->carisma : "8" ?></td>
                                    </tr>
                                    <tr>
                                        <th>Modificador</th>
                                        <td id="txtCarismaModificador"><?php echo (isset($personaje->carisma)) ? obtenerModificador($personaje->carisma) : "-1" ?></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" id="btnSiguiente" name="siguiente" value="Siguiente" class="centrado"></td>
                </tr>
            </table>
        </form>
    </section>
</main>
<?php
require_once "../includes/footer.php"
?>
<script src="../../js/menuHamburguesa.js"></script>
<script src="../../js/compraPuntos.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        cargarDesdeSelect("trasfondo", "infoTrafondo", "<?php echo "../includes/peticiones.php";  ?>", "trasfondo");
    });
</script>
<script>
    const div = document.getElementById("infoTrafondo");

    const observer = new MutationObserver(function(mutations) {
        fijarValorTotal();
    });

    observer.observe(div, {
        childList: true, // cambios en hijos
        subtree: true, // también dentro de hijos
        characterData: true // cambios de texto
    });
</script>
</body>

</html>