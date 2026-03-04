<?php
require_once "../utility/utils.php";

comprobarLogin();
if (!isset($_SESSION['personaje']) || isset($_POST["anterior"])) {
    header("Location: ./crearPersonaje.php");
    exit();
}
$personaje = $_SESSION["personaje"];

if (isset($_POST['siguiente'])) {
    // $personaje = new stdClass();
    // $personaje->nombre = $_POST["nombrePj"];
    // $personaje->raza = $_POST["raza"];
    // $personaje->clase = $_POST["clase"];
    // $personaje->trasfondo = $_POST["trasfondo"];
    // $personaje->fuerza = $_POST["selectFuerza"];
    // $personaje->destreza = $_POST["selectDesteza"];
    // $personaje->constitucion = $_POST["selectConstitucion"];
    // $personaje->inteligencia = $_POST["selectInteligencia"];
    // $personaje->sabiduria = $_POST["selectSabiduria"];
    // $personaje->carisma = $_POST["selectCarisma"];
    // $_SESSION['personaje'] = $personaje;
    // header("Location: ./crearPersonaje2.php");
    // exit();
}




//TODO cargar el select
require_once "../includes/header.php";
?>
<main>
    <!-- Informacion de la Pagina -->
    <section class="contenedor">
        <form action="" method="post">
            <h2><?php echo $personaje->raza; ?></h2>
            <select name="subraza" id="subraza">
                <option value="SUBRAZA">SUBRAZA</option>
            </select>
            <div>
                CARACTERISTICAS DE LA RAZA Y SUBRAZA
            </div>
            <div>
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