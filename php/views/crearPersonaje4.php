<?php
require_once "../utility/utils.php";
require_once "../utility/conexion.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"]) || !isset($_SESSION['personaje']->datosClase)) {
    header("Location: ./crearPersonaje3.php");
    exit();
}
$personaje = $_SESSION["personaje"];

if (isset($_POST['finalizar'])) {
    $personaje->equipoClase = $_POST["equipoClase"];
    $personaje->equipoTrasfondo = $_POST["equipoTrasfondo"];
    putCharacter(getCon(),$_SESSION['user'][0]->user_nick,$personaje->nombre,
    $personaje->raza, $personaje->clase, $personaje->trasfondo,$personaje->fuerza,
    $personaje->destreza,$personaje->constitucion,$personaje->inteligencia,$personaje->sabiduria,
    $personaje->carisma,$personaje->pg,$personaje->subraza);
    $personaje=null;
    header("Location: ./personajes.php");
    exit();
}




//TODO cargar el select
require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $personaje->nombre; ?></h2>
            <table>
                <tr>
                    <td>
                        <select name="equipoClase" id="equipoClase">
                            <option value="equipoClase">equipoClase</option>
                        </select>
                    </td>
                    <td>
                        <select name="equipoTrasfondo" id="equipoTrasfondo">
                            <option value="equipoTrasfondo">equipoTrasfondo</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div>
                            ITEMS CLASE
                        </div>
                    </td>
                    <td>
                        <div>
                            ITEMS TRASONFO
                        </div>
                    </td>
                </tr>
            </table>
            <div>
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
</body>

</html>