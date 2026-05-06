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
    $personaje->equipoClase = $_POST["equipoClase"];
    $personaje->equipoTrasfondo = $_POST["equipoTrasfondo"];
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

    header("Location: ./personajes.php");
    exit();
}

//TODO acabar cuando esten relacionados en la db
// $equipoClase;

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