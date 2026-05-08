<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

//comprobar si se ha hecho login
comprobarLogin();

//volver atras
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->competenciasClase)) {
    header("Location: ./crearPersonaje3.php");
    exit();
}

//cargar el personaje
$personaje = $_SESSION["personaje"];

//si se quiere finalizar la creacion
if (isset($_POST['finalizar'])) {
    //cargar equipo trasfondo
    $trasfondo = getBackground(getCon(), $personaje->trasfondo)[0];
    $gp = 0;
    $items = [];
    $bundleTrasfondo = getBundle(getCon(), $trasfondo->bundle_id)[0];
    if ($_POST["equipoTrasfondo"] == "oro") {
        $gp += $bundleTrasfondo->bundle_price;
    } else {
        $gp += $bundleTrasfondo->extra_gp;
        $itemsTrasfondo = getBundleItems(getCon(), $trasfondo->bundle_id);
        foreach ($itemsTrasfondo as $item) {
            $items[] = $item;
        }
    }

    //cargar equipo clase
    $claseBundle = getClassBundle(getCon(), $personaje->clase);
    $precio = getBundle(getCon(), $claseBundle[0]->bundle_id)[0];
    $itemsClase = [];
    if ($_POST["equipoClase"] == "oro") {
        $gp += $precio->bundle_price;
    } else {
        if ($_POST["equipoClase"] == "items") {
            $itemsClase = getBundleItems(getCon(), $claseBundle[0]->bundle_id);
        } else {
            $itemsClase = getBundleItems(getCon(), $claseBundle[1]->bundle_id);
            $precio = getBundle(getCon(), $claseBundle[1]->bundle_id)[0];
        }
        $gp += $precio->extra_gp;
        foreach ($itemsClase as $item) {
            foreach ($items as $key => $existingItem) {
                if ($existingItem->item_id === $item->item_id) {
                    $item->item_count += $existingItem->item_count;
                    unset($items[$key]);
                    break;
                }
            }
            $items[] = $item;
        }
    }

    //cargar habilidades
    $habilidades = [];
    foreach ($personaje->competenciasClase as $habilidad) {
        if (!in_array($habilidad, $habilidades) && $habilidad - 100 > 0 && $habilidad - 100 < 19) {
            $habilidades[] = $habilidad - 100;
        }
    }
    foreach ($personaje->competenciasRaza as $habilidad) {
        if (!in_array($habilidad, $habilidades) && $habilidad - 100 > 0 && $habilidad - 100 < 19) {
            $habilidades[] = $habilidad - 100;
        }
    }
    if (
        !in_array($personaje->skillAdicional, $habilidades) && $personaje->skillAdicional > 0
        && $personaje->skillAdicional < 19
    ) {
        $habilidades[] = $personaje->skillAdicional;
    }

    //cargar competencias
    $competencias = [];
    foreach ($personaje->competenciasClase as $competencia) {
        if (!in_array($competencia, $competencias) && !in_array($competencia - 100, $habilidades)) {
            $competencias[] = $competencia;
        }
    }
    foreach ($personaje->competenciasRaza as $competencia) {
        if (!in_array($competencia, $competencias) && !in_array($competencia - 100, $habilidades)) {
            $competencias[] = $competencia;
        }
    }
    $personaje->habilidades = $habilidades;
    $personaje->competencias = $competencias;

    //crear el personaje
    $idPersonaje = putCharacter(
        getCon(),
        $_SESSION['user'][0]->user_nick,
        $personaje->nombre,
        $personaje->raza,
        $personaje->clase,
        $personaje->trasfondo,
        $personaje->fuerza,
        $personaje->destreza,
        $personaje->constitucion,
        $personaje->inteligencia,
        $personaje->sabiduria,
        $personaje->carisma,
        $personaje->pg,
        $personaje->ca,
        $personaje->iniciativa,
        $gp,
        $personaje->subraza
    );

    //poner las habilidades y las pericias al personaje
    if (isset($personaje->pericias)) {
        foreach ($personaje->habilidades as $habilidad) {
            if (in_array($habilidad, $personaje->pericias)) {
                putCharacterSkillProficiency(getCon(), $idPersonaje, $habilidad, "expertise");
            } else {
                putCharacterSkillProficiency(getCon(), $idPersonaje, $habilidad);
            }
        }
    } else {
        foreach ($personaje->habilidades as $habilidad) {
            putCharacterSkillProficiency(getCon(), $idPersonaje, $habilidad);
        }
    }
    //poner las competencias al personaje
    foreach ($personaje->competencias as $competencia) {
        putCharacterProficiency(getCon(), $idPersonaje, $competencia);
    }

    //poner los trucos al personaje si tiene
    if (isset($personaje->trucos)) {
        foreach ($personaje->trucos as $spell) {
            putCharacterSpell(getCon(), $idPersonaje, $spell);
        }
    }

    //poner los conjuros de nivel 1 al personaje si los tiene
    if (isset($personaje->nivel1)) {
        foreach ($personaje->nivel1 as $spell) {
            putCharacterSpell(getCon(), $idPersonaje, $spell);
        }
    }

    //poner los items al personaje
    foreach ($items as $item) {
        putCharacterInventory(getCon(), $idPersonaje, $item->item_id, $item->item_count);
    }

    //poner las dotes al personaej
    foreach ($personaje->dotes as $dote) {
        putCharacterFeat(getCon(), $idPersonaje, $dote);
    }

    //poner las maestrias la personaje si las tiene
    if (isset($personaje->maestrias)) {
        foreach ($personaje->maestrias as $maestria) {
            putCharacterItemMastery(getCon(), $idPersonaje, $maestria);
        }
    }
    header("Location: ./personajes.php");
    exit();
}

require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2>Equipo</h2>
            <table>
                <tr>
                    <td>
                        <h3 class="centrado">Clase</h3>
                        <select name="equipoClase" id="equipoClase">
                            <?php
                            //mostrar las opciones en funcion de si es un geurrero
                            if ($personaje->clase == 5) {
                                echo "<option value='items'>Objetos (A)</option>";
                                echo "<option value='items2'>Objetos (B)</option>";
                            } else {
                                echo "<option value='items'>Objetos</option>";
                            }
                            ?>
                            <option value="oro">Oro</option>
                        </select>
                    </td>
                    <td>
                        <h3 class="centrado">Trasfondo</h3>
                        <select name="equipoTrasfondo" id="equipoTrasfondo">
                            <option value="items">Objetos</option>
                            <option value="oro">Oro</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <!-- divs cuyo contenido va a cambiar para mostrar los items de la clase y el trasfondo o el oro que dan -->
                    <td style="width: 50%;">
                        <div id='itemsClase'>
                        </div>
                    </td>
                    <td style="width: 50%;">
                        <div id="itemsTrasfondo">
                        </div>
                    </td>
                </tr>
            </table>
            <hr class="ocupaTodo">
            <div class="centrado">
                <input type="submit" name="anterior" value="Anterior">
                <input type="submit" name="finalizar" value="Finalizar">
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
        cargarDesdeSelect("equipoTrasfondo", "itemsTrasfondo", "<?php echo "../includes/peticiones.php";  ?>", "itemsTrasfondo");
        cargarDesdeSelect("equipoClase", "itemsClase", "<?php echo "../includes/peticiones.php";  ?>", "itemsClase");
    });
</script>
</body>

</html>