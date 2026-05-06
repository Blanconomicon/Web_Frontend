<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->competenciasClase)) {
    header("Location: ./crearPersonaje3.php");
    exit();
}
$personaje = $_SESSION["personaje"];

if (isset($_POST['finalizar'])) {
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
    $habilidades = $personaje->competenciasClase;
    foreach ($personaje->competenciasRaza as $habilidad) {
        if (!in_array($habilidad, $habilidades)) {
            $habilidades[] = $habilidad;
        }
    }
    $personaje->habilidades = $habilidades;
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

    foreach ($personaje->habilidades as $habilidad) {
        putCharacterSkillProficiency(getCon(), $idPersonaje, $habilidad, "proficient");
    }
    if (isset($personaje->trucos)) {
        foreach ($personaje->trucos as $spell) {
            putCharacterSpell(getCon(), $idPersonaje, $spell);
        }
        foreach ($personaje->nivel1 as $spell) {
            putCharacterSpell(getCon(), $idPersonaje, $spell);
        }
    }

    foreach ($items as $item) {
        echo "<p>INTENTO</p>";
        putCharacterInventory(getCon(), $idPersonaje, $item->item_id, $item->item_count);
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
                        <select name="equipoClase" id="equipoClase">
                            <?php
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
                        <select name="equipoTrasfondo" id="equipoTrasfondo">
                            <option value="items">Objetos</option>
                            <option value="oro">Oro</option>
                        </select>
                    </td>
                </tr>
                <tr>
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